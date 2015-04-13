---
layout: post
title: "Raspberry Pi As a Home Base"
date: 2013-09-03 16:37
comments: true
categories: rpi
---

I bought a Raspberry Pi the other day to set it up as a Wifi Access Point.
I had a bit of trouble setting up, so I decided to document what I was doing in case I need to do it again.

Feel free to let me know about any issues/etc in the comments, or [on twitter](https://twitter.com/shalecraig).

Consider this a WIP.

## A false start

Started by buying [this USB Wireless LAN adapter](http://www.amazon.com/gp/product/B008Z9IZSW/ref=oh_details_o00_s00_i00?ie=UTF8&psc=1).

The chipset is reported to be a Ralink RT5370, but when you plug it in, it's actually a Ralink RT2870/RT3070. Skip to the next part if you don't care about my false start.

I've basically followed the tutorial on [sirlagz's site](http://sirlagz.net/2012/08/09/how-to-use-the-raspberry-pi-as-a-wireless-access-pointrouter-part-1/).

- Load & boot Raspbian. I used [this tutorial](http://elinux.org/RPi_Easy_SD_Card_Setup#Using_command_line_tools_.281.29).
- Update installed packages:
```bash
$ sudo apt-get update
$ sudo apt-get dist-upgrade
$ sudo apt-get upgrade
$ sudo reboot
```
- Install required packages:
```bash
$ sudo apt-get install iw hostapd
```
- Check that the wireless device is found:
```bash
$ lsusb | grep Ralink
Bus 001 Device 006: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
```
Well, it looks like the device I bought was not the one advertised on the Amazon page. I went to Amazon for a refund, and got my money back.

### Set Up The Raspberry Pi While I Wait For "A New Beginning" to be Unblocked (Tomorrow)

I'm going to try to set up the first wifi adapter to connect to wireless networks.

After following the modification instructions on [this raspberrypi.org forum post](http://www.raspberrypi.org/phpBB3/viewtopic.php?p=361671),
I ran `dmesg` and saw the error:

```
[   45.793616] phy0 -> rt2800_init_eeprom: Error - Invalid RF chipset 0x3070 detected.
```

According to [this page](http://www.geekamole.com/2013/rt2800usb-fix-for-ralinkmediatek-3070-gentoo-linux/),
I *just* need to compile the kernel. That's great, because a quick trip to [elinux.org](http://elinux.org/RPi_Kernel_Compilation) later, and
I'm ready to start compiling!

Wow, compiling is hard. I ran into the error below, and decided to go a different route.
More on that below the error.
```bash
$ make mrproper
Makefile:323: /home/pi/kernel/src/linux/scripts/Kbuild.include: No such file or directory
/bin/bash: /home/pi/kernel/src/linux/scripts/gcc-goto.sh: No such file or directory
make[1]: scripts/Makefile.clean: No such file or directory
make[1]: *** No rule to make target `scripts/Makefile.clean'.  Stop.
make: *** [_clean_.] Error 2
```

Found a [blog post](http://lizquilty.com/2010/06/08/getting-the-rt3070-usb-wifi-adapter-working-in-linux/) by [Liz Quilty](http://lizquilty.com/).
Seems simple enough.

Downloaded the driver [from here](http://download.modem-help.co.uk/mfcs-R/Ralink/Reference-Designs/RT3000U/Drivers/Linux-k2-4/v2-3-0-2/DPO-RT3070-LinuxSTA-V2.3.0.2-20100412.bz2.php).
This isn't sketchy at all.

Holy crap, my SD card is full. I should probably delete the 2 gig raspbian OS I put on there earlier. ``rm -rf ~/kernel`` Done.

After a bit of frantic googling, I was able to find [this ko file](http://androideia.wordpress.com/2013/07/20/problemas-com-adaptador-usb-wi-fi-ralink-2870-3070-em-raspberry-pi-e-linux/), and installed it on my system.
After a reboot, and replugging in the usb, this is what I found:
```bash
$ dmesg
{...}
[   61.794219] usb 1-1.3.2: new high-speed USB device number 7 using dwc_otg
[   61.912143] usb 1-1.3.2: New USB device found, idVendor=148f, idProduct=3070
[   61.912173] usb 1-1.3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   61.912191] usb 1-1.3.2: Product: 802.11 n WLAN
[   61.912205] usb 1-1.3.2: Manufacturer: Ralink
[   61.912218] usb 1-1.3.2: SerialNumber: 1.0
```

Running `iw list` returns `nl80211 not found.`

According to [this pull request on the rpi github repo](https://github.com/raspberrypi/linux/pull/321), someone's fixed it already but it isn't in master yet.
Now all I need to do is to check out the branch, cherry-pick the change, and compile the kernel. **No biggie**.

Heading back to the [elinux](http://elinux.org/RPi_Kernel_Compilation#Cross_compiling_from_OSX) page, I notice that I can try cross-compiling rpi on OS X; let's do that instead.

```bash
# On my mac:
mkdir -p ~code/rpi
cd ~code/rpi
git init
git fetch git://github.com/raspberrypi/linux.git rpi-3.6.y:refs/remotes/origin/rpi-3.6.y
git checkout rpi-3.6.y
sudo port install arm-none-eabi-gcc
sudo port install arm-none-eabi-binutils
```

Now that it's setup, let's do this for real:
```bash
make mrproper
```

Hmm, it's failing because `elf.h` is missing.
According to the elinux site, I can get it from the apple developer site.

<!-- TODO: add curl here -->

Now that it's setup, let's do this for real:
```bash
make mrproper
```

Hmm, it's failing with the error message below.
```bash
net/ipv4/netfilter/ipt_ECN.c:29:46: warning: ‘struct ipt_ECN_info’ declared inside parameter list [enabled by default]
{snip ... 41 lines}
make[3]: *** [net/ipv4/netfilter/ipt_ECN.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
```

A quick google search lets me know that the file system that I'm using is case-insensitive.
Setting up a linux dev env on a usb stick:

**Note: I used Disk Utility to setup this external usb disk. You can create your own image, but I was lazy**
```bash
cd ~code/rpi
cp -r . /Volumes/LINUX_DEV/
make ARCH=arm CROSS_COMPILE=${CCPREFIX}
```

After a [few](http://www.raspberrypi.org/phpBB3/viewtopic.php?t=43553&p=366029) compilation errors, I ran into this error:

```bash
net/ipv4/netfilter/ipt_ECN.c:20:42: fatal error: linux/netfilter_ipv4/ipt_ECN.h: No such file or directory
compilation terminated.
make[3]: *** [net/ipv4/netfilter/ipt_ECN.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
```

According to [this blog](http://ubuntuforums.org/archive/index.php/t-623874.html), I need to have `gcc 4.1` installed.
After running `gcc --version`, it looks like I'm running `i686-apple-darwin11-llvm-gcc-4.2 (GCC) 4.2.1`.

At this point, I have to go to a friends house for dinner, and I don't feel like installing gcc 4.1 when I have a functioning gcc 4.2 installed.

### After Dinner

My friend's father was talking all about how he has [OpenELEC](http://openelec.tv/) installed on his rpi, and about how it's been working flawlessly.
Unlike [the Raspberry pi kernel](https://github.com/raspberrypi/linux/pull/321), I believe that OpenELEC [already supports](https://github.com/OpenELEC/OpenELEC.tv/issues/2435) my Ralink 3070 adapter.

New plan of action: **Boot my Raspberry pi using OpenELEC**

- Downloaded the [OpenELEC.img](http://openelec.thestateofme.com/)
- [Used `dd`](http://wiki.openelec.tv/index.php?title=Installing_OpenELEC_on_Raspberry_Pi#tab=Mac_OSX) to load it on the SD card.
- Put the SD card into the Raspberry Pi.
- Boot it.

It looks like OpenELEC [is read-only](http://openelec.tv/forum/64-installation/36491-raspberry-pi) :(.
Going to try RaspBMC instead.

- Following the tutorial on [this page](http://www.raspbmc.com/wiki/user/os-x-linux-installation/).
- After I booted RaspBMC, it looks like it doesn't support the RT3070 I have.

I'm going to submit a pull request to include it in Raspbian, my OS of choice.

As of right now, I'm waiting on the pull request to be merged.

## A New Beginning

I got started by buying [this USB Wireless LAN adapter](http://www.amazon.ca/gp/product/B008IFXQFU/ref=oh_details_o00_s00_i00?ie=UTF8&psc=1), and it hasn't come yet.

I'm going to follow the instructions on a [raspberrypi.org forum post](http://www.raspberrypi.org/phpBB3/viewtopic.php?f=26&t=49355) to get it working.

It arrived a few days ago, and I'm set to start!

- Install/Boot Raspbian
- After the initial setup, plugging in the wifi adapter caused the Raspberry Pi to reboot. I'm cautious to see that it's underpowered, and will probably watch for that happening in the future.
- SSH in, update installed packages:
```bash
$ sudo apt-get update
E: Unable to parse package file /var/lib/dpkg/status (1)
E: The package lists or status file could not be parsed or opened.
```
- Quick google search let me know that something is corrupted, and that I should probably re-image the card.
```bash
sudo dd bs=1m if=~/Downloads/2013-07-26-wheezy-raspbian.img of=/dev/disk1
```
- Hop back on the pi machine:
```bash
$ sudo apt-get update
$ sudo apt-get dist-upgrade
$ sudo apt-get upgrade
$ sudo raspi-config
$ sudo reboot
```
- Install required packages:
```bash
$ sudo apt-get install iw hostapd
```

- In the output, I noticed that I haven't set up a locale. I should probably do that: <!-- TODO: do this -->
```bash
perl: warning: Please check that your locale settings:
    LANGUAGE = (unset),
    LC_ALL = (unset),
    LC_CTYPE = "en_CA.UTF-8",
    LANG = "en_GB.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
```
- I need to install the new version of the driver:
```bash
mkdir wifiDriver
cd wifiDriver
wget https://dl.dropboxusercontent.com/u/80256631/8188eu-20130209.tar.gz
tar -zxvf 8188eu-20130209.tar.gz
sudo install -p -m 644 8188eu.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless
sudo depmod -a
sudo modprobe 8188eu
```
- The `modprobe 8188eu` command errored out with the error below, so I followed the steps [here](http://tech.enekochan.com/2013/05/29/compile-and-install-driver-for-tp-link-tl-wn725n-version-2-in-raspbian/).
```bash
$ git clone https://github.com/liwei/rpi-rtl8188eu.git
$ git clone --depth 1 git://github.com/raspberrypi/linux.git rpi-linux
$ git clone --depth 1 git://github.com/raspberrypi/firmware.git rpi-firmware
$ cd rpi-linux
$ make mrproper
$ zcat /proc/config.gz > .config
$ make modules_prepare
$ cp ../rpi-firmware/extra/Module.symvers .
$ cd ../rpi-rtl8188eu
$ CONFIG_RTL8188EU=m make -C ../rpi-linux M=`pwd`
$ sudo rmmod 8188eu
> Error: Module 8188eu is not currently loaded
$ sudo install -p -m 644 8188eu.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless # next
$ sudo depmod -a
$ sudo modprobe 8188eu
```

It failed :(
```bash
ERROR: could not insert '8188eu': Exec format error
```

After this, I was a bit discouraged, and school was about to start again.
I posted something to the effect of "please merge this" to that [github pull request](https://github.com/raspberrypi/linux/pull/321), and it (miraculously) was merged.

[PopcornMix](https://github.com/popcornmix), the maintainer (I think) mentioned that if I ran `rpi-update`, I'd be able to test & verify that it worked.

It didn't.

After a bit of investigation when I moved into my room at school on Monday, I established that [Hexxeh](https://github.com/Hexxeh)'s `rpi-update` repo was compiled on a schedule.
School was starting (This was Sept 7th), so I decided to wait.

## It works!

On Sept 13th, I finally got my adapter to be recognized by the system.
I ran `rpi-update` and after rebooting it recognized the driver.

```bash
$ iw list
> ...[returns a lot]
```
:D

Next step: see if I can set it up to be an access point.
I'm almost sure that nobody has set this up with this chip on a raspberry pi before.
This is awesome.

Here are the steps that I've taken, from a clean install:

```bash
# Expand the file system
$ sudo apt-get install iw
$ iw list # verify the wifi dongle is not found.
$ sudo rpi-update BRANCH=next # The driver is supported only on the `next` branch.
$ sudo reboot # reboot to actually install the update
$ iw list # check that the device is seen
$ sudo reboot
$ iw list # check that the device is seen - I ran into an issue where the update was `undone` after a reboot.
$ ifconfig -a # check that the usb adapter is there, it should be listed as `wlan0` if you only have one wifi adapter
$ sudo apt-get install ca-certificates dnsmasq hostapd iptables isc-dhcp-server iw udhcpd vim
```

I'm not running `sudo apt-get upgrade` because that will update Raspberry Pi to the stable (non-'next branch') version.
See [this post](http://www.raspberrypi.org/phpBB3/viewtopic.php?f=28&t=55576&p=421733) for more details if you're curious.

After getting everything set up, I followed the [wonderful Adafruit tutorial](http://learn.adafruit.com/setting-up-a-raspberry-pi-as-a-wifi-access-point/overview) on setting up my Raspberry Pi as an Access point.

The only points I needed to change were:

- I used `driver=nl80211` in my `hostapd.conf` file. I'm not sure how to determine which one works, but this is what I used.

-

## Plan:

I want to see if I can do all of these at the same time:

- Use as a wifi Access Point

- Setup a local DNS server on the Raspberry Pi

- Samba file server

- Mac Address filtering/logging - when am I home/etc?

- Airplay "destination" - I should be able to play music through speakers hooked up to it

- Block ads on my access point.
