# klipper_configs

## GitHub Ratelimit

There are many github api requests for kiauh. In order to not be ratelimited you should authenticate with:

```shell
curl -u "fire1ce" https://api.github.com
```

## rpi setup

Install

```shell
wget https://raw.githubusercontent.com/fire1ce/debianUpdate/master/sysupgrade.sh
sudo chmod +x sysupgrade.sh
sudo mv sysupgrade.sh /usr/bin/sysupgrade
```

Make full dist upgrade

```shell
sysupgrade
```

Install additional packages

```shell
sudo apt install -y curl wget git dnsutils whois net-tools htop locate telnet traceroute screenfetch bpytop zsh speedtest-cli
```

- [https://github.com/th33xitus/kiauh](https://github.com/th33xitus/kiauh)

Install with kiauh:

- Klipper
- Moonraker
- Mainsail
- Telegram Bot
- KlipperScreen

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

## sonar and crowsnest

Install:

- [https://github.com/mainsail-crew/sonar](https://github.com/mainsail-crew/sonar)
- [https://github.com/mainsail-crew/crowsnest](https://github.com/mainsail-crew/crowsnest)

## Restore the configs

Backup the original `config` folder and create a symlink to git repo `config` folder

```shell
rm -rf /home/pi/printer_data/config
rm -rf /home/pi/configs
git clone git@github.com:fire1ce/ender3s1_klipper-configs.git /home/pi/printer_data/config
ln -s /home/pi/printer_data/config /home/pi/configs
cd /home/pi/printer_data/config
git config pull.rebase false
git config --global user.email "mainsail@3os.re"
git config --global user.name "mainsail@3os.re"
cd ~
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
