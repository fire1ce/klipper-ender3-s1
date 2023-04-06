# Klipper Mainsailos

This is a configuration for Klipper and Mainsail on a Raspberry Pi for a **Creality Ender 3 S1 Pro**.

The configuration is based on mainsailos and the following guides:

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
git clone git@github.com:fire1ce/klipper-mainsail.git /home/pi/printer_data/config
ln -s /home/pi/printer_data/config /home/pi/configs
```

## Alias for zsh and usage

```shell
nano ~/.zshrc
```

```shell
alias htop='bpytop'
alias top='bpytop'
alias kiauh='/home/pi/kiauh/kiauh.sh'
alias git-push='git add . && git commit -m $(date +'%Y%m%d.%H%M') && git push'
```

```shell
echo "usage: $ kiauh"
```

## Push to Git every boot

Set the conjob with pi user (root not needed)

```shell
@reboot nohup /home/pi/printer_data/config/git-push.sh >> /home/pi/git-push.log /dev/null 2>&1 &
```

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
