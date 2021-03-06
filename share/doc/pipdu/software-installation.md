# PiPDU software installation and setup #

## Install `pipdush` and `pipductl` ##

Copy bash scripts
```
$ sudo cp ../../../bin/pipdush.bash /usr/bin/pipdush.bash
$ sudo cp ../../../bin/pipductl.bash /usr/bin/pipductl.bash
```

Create symlinks
```
$ sudo ln -s pipdush.bash /usr/bin/pipdush
$ sudo ln -s pipductl.bash /usr/bin/pipductl
```

Copy exemplary PiPDU configuration file
```
$ sudo cp ../../../etc/pipdu.conf /etc/pipdu.conf
```

> **NOTICE:** The `pipdush` shell requires the `send` command from the [Raspberry Pi Remote] project as `rf433send` in `/usr/bin`.

[Raspberry Pi Remote]: https://github.com/xkonni/raspberry-remote

## Create PiPDU user and allow access to GPIOs ##

Prepare home directory
```
$ mkdir /home/pipdu
$ sudo touch /home/pipdu/.hushlogin
```

Create user and avoid copying of skeleton files
```
$ sudo adduser --home "/home/pipdu" pipdu
$ sudo chown -R pipdu: /home/pipdu
```

Allow access to GPIOs
```
$ sudo adduser pipdu gpio
```

## Configure available power outlets ##

As the PiPDU library uses _binary mode_ for sending commands to the power outlets, you can use up to 31 power outlets for a single _system code_. If a _unit code_ of "0" would work with the `(rf433)send` command, one additional power outlet would be possible per _system code_, but the `(rf433)send` command segfaults with a _unit code_ of "0". I prefer to use different _system_ and _unit codes_ for each power outlet, which would allow the usage of even more power outlets from a single PiPDU. Before using the PiPDU tools you need to configure the _system_ and _unit codes_ of the power outlets in `/etc/pipdu.conf`. Notice that the _system code_ has to be given in binary form (e.g. "10101") and the _unit code_ has to be given in decimal form (e.g. "31" for "ABCDE" configured to "11111").

Examplary `/etc/pipdu.conf`:
```
# PiPDU configuration file

# Name of the PiPDU
_piPduName="pdu1"

# PiPDU shell prompt
_piPduShellPrompt="${USER}@PiPDU> "

# PiPDUShell timeout in seconds
_piPduShellTimeout=60

# Command to use for sending RF commands
_piPduSendCommand="/usr/bin/rf433send"

# GPIO pin to use with the RF transmitter (usually 17)
_piPduGpioPinNo=17

# Configure the used outlets
_piPduOutlets=( 
"11111;1"
"11111;2"
)
```

The PiPDU configuration file is sourced by the PiPDU library and hence uses the bash shell syntax.

## Configure access to the PiPDU shell via SSH and serial console ##

1. Change the shell of the pipdu user to `/usr/bin/pipdush`, either via modifying `/etc/passwd` directly or by using `chsh`. This already allows access via SSH by providing username and password of the pipdu user. You can also make use of public SSH keys in addition.

2. To also enable access via a serial console, add a usb to serial converter to the Raspberry Pi (**before* starting up for pre B+ Raspberry Pis). Then add a line similar to the following to `/etc/inittab`:
```
T1:23:respawn:/sbin/getty -L ttyUSB0 115200 vt100
```
You need to use the TTY device that corresponds to your USB to serial adapter and another value as "T0" for the ID column (e.g. "T1"), because "T0" is the serial console for the internal serial port. I prefer to use the same baud rate as for the internal serial port, so you only need to remember one baud rate setting for your PiPDU.

Of course you can also skip this configuration and just use the internal serial port, but depending on your kernel command line, kernel console messages could be emitted on the internal serial port during a session then.

> **NOTICE:** The USB to serial adapter needs to be available and usable when init starts!

