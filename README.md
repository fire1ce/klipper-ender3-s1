# Klipper Mainsailos

This is a configuration for Klipper and Mainsail on a Raspberry Pi for a **Creality Ender 3 S1 Pro**.

The configuration is based on **Mainsailos** and the following guides:

- [https://docs.mainsail.xyz/setup/getting-started](https://docs.mainsail.xyz/setup/getting-started)

First of all install the MainSailOS with **Raspberry Pi Imager**.

## Github Preparations

**Note:** Change the usernames and emails.

```shell
git config --global pull.rebase false
git config --global user.email "mainsailos@3os.re"
git config --global user.name "mainsailos@3os.re"
```

## Raspberry Pi Configuration

Enable SPI and I2C

```shell
sudo raspi-config
```

Under `Interfacing Options` enable `SPI` and `I2C`

## Install Additional Packages for "Input Shaping"

```shell
sudo apt update && sudo apt install -y python3-numpy python3-matplotlib libatlas-base-dev
```

Then run the following:

```shell
~/klippy-env/bin/pip install -v numpy
```

Follow this docs:

- [https://www.klipper3d.org/RPi_microcontroller.html](https://www.klipper3d.org/RPi_microcontroller.html)

## Restore the configs

Backup the original `config` folder and create a symlink to git repo `config` folder

```shell
cd ~ 
rm -rf /home/pi/printer_data/config
git clone git@github.com:fire1ce/klipper-ender3-s1.git /home/pi/printer_data/config
ln -s /home/pi/printer_data/config /home/pi/configs
```

## Macros

We will base our macros on the following repo:

- [https://github.com/jschuh/klipper-macros](https://github.com/jschuh/klipper-macros)

To install the macros, first clone this repository inside of your printer_data/config directory with the following command.

```shell
git clone https://github.com/jschuh/klipper-macros.git /home/pi/printer_data/config/klipper-macros
```

Follow this for Slicer Configuration:

- [https://github.com/jschuh/klipper-macros#slicer-configuration](https://github.com/jschuh/klipper-macros#slicer-configuration)

## Setting up System Configs

oh-my-zsh config

```shell
rm -rf /home/pi/.zshrc
ln -s /home/pi/printer_data/config/.system-configs/zshrc /home/pi/.zshrc
```

SSH config

```shell
rm -rf /home/pi/.ssh/config
mkdir -p /home/pi/.ssh
ln -s /home/pi/printer_data/config/.system-configs/ssh_config /home/pi/.ssh/config
```

## Pushing the configs to Github on change

Install inotify-tools for watching the config folder

```shell
sudo apt-get update
sudo apt install -y inotify-tools
```

Log file will be created in `/home/pi/git-push.log`

Set the Cronjob with pi user (root not needed)

```shell
@reboot nohup /home/pi/printer_data/config/.system-configs/git-push.sh >> /home/pi/git-push.log /dev/null 2>&1 &
```

## Setting up Dynamic Print Surfaces

**Work In Progress**


We will Set the Z Offset of the Probe to 0.0 and use the Dynamic Print Surface feature of Macros.

form `macros-init.cfg`
we set the following:

```shell
variable_bed_surfaces: ['texture','smooth','pc',]
```

Display the surfaces with the following command `*` is the current active surface:

```shell
SET_SURFACE_ACTIVE
``` 

Let's show to to configure the `texture` surface.

```shell
SET_SURFACE_ACTIVE SURFACE=texture
```

```shell
G28
probe_calibrate
abort
```


```shell
SET_SURFACE_OFFSET OFFSET=2.645
```

## Klipper Screen and WaveShare 7" DSI LCD

[WaveShare 7" DSI LCD Official Page](https://www.waveshare.com/wiki/7inch_DSI_LCD_(C))

Install the drivers for the LCD Display

[Waveshare LCD Drivers Github Page](https://github.com/waveshare/Waveshare-DSI-LCD)

In my configuration i need to rotate the display and the touch input by 180°

The working solution i found is to use the KlipperScreen's way to rotate the display.

```shell
sudo nano /usr/share/X11/xorg.conf.d/90-monitor.conf
```

My config:

```shell
Section "Monitor"
    # This identifier would be the same as the name of the connector printed by xrandr.
    # it can be "HDMI-0" "DisplayPort-0", "DSI-0", "DVI-0", "DPI-0" etc
    Identifier "DSI-1"

    # Valid rotation options are normal,inverted,left,right
    Option "Rotate" "inverted"

    # May be necesary if you are not getting your prefered resolution.
    Option "PreferredMode" "1024x600"

EndSection
```

Restart KlipperScreen Service

```shell
sudo service KlipperScreen restart
```

This should rotate the display of the KlipperScreen 180°

In order to rotate the touch input we need editing the `/boot/config.txt` config.

```shell
sudo nano /boot/config.txt
```
At the end of the config file after installing the WaveShare Drivers you should have the following:

```shell
[all]
ignore_lcd=1
dtparam=i2c_vc=on
dtoverlay=WS_xinchDSI_Screen,SCREEN_type=2,I2C_bus=1
dtoverlay=WS_xinchDSI_Touch,I2C_bus=1
```

We need to add `invertedx,invertedy` to the `dtoverlay=WS_xinchDSI_Touch' line.

The lcd part should look like this:

```shell
[all]
ignore_lcd=1
dtparam=i2c_vc=on
dtoverlay=WS_xinchDSI_Screen,SCREEN_type=2,I2C_bus=1
dtoverlay=WS_xinchDSI_Touch,I2C_bus=1,invertedx,invertedy
```

Reboot the Pi

At this point the display should be rotated 180° and the touch input should be rotated 180° and klipperScreen should be working.

### Install KlipperScreen

Use kiauh to install KlipperScreen

[kiauh Github Page](https://github.com/th33xitus/kiauh)

## Troubleshooting

Follow any errors in the log file

```shell
sudo dmesg -w
```

### "Klipper" - Services

```shell
systemctl status KlipperScreen
```

#### (EE) xf86OpenConsole: Cannot open virtual console 2 (Permission denied)

Fix with:

```shell
sudo bash -c "echo needs_root_rights=yes>>/etc/X11/Xwrapper.config"
```

### Failed to query (GET_INFO) UVC control 2 on unit 1: -32 (exp. 1).

This Error is from the Microphone on the USB Camera.
You can black list the usb audio driver to prevent this error.

```shell
sudo nano /etc/modprobe.d/raspi-blacklist.conf
```

```shell
blacklist snd_usb_audio,snd_bcm2835
```
