# PiPDU #

The PiPDU is a project that offers the functionality of a remote controllable PDU in a cheap way. It's based on several other projects ([Raspberry Pi Remote] which itself is based on [RCSwitch] and [WiringPi]) and some articles ([Heimautomation mit dem Raspberry Pi] \[de\], [Adding 433 to your Raspberry Pi]). The software uses an off-the-shelf 433 MHz transmitter to control radio controllable power outlets with 433 MHz receivers. For ease of use this project also offers a shell-like interface named PiPDUShell which can be accessed via network or a serial console (e.g. for manual usage or for usage with [in-control]).

[Raspberry Pi Remote]: https://github.com/xkonni/raspberry-remote
[RCSwitch]: https://github.com/sui77/rc-switch
[WiringPi]: http://wiringpi.com/
[in-control]: https://github.com/the-machine-hall/in-control

[Heimautomation mit dem Raspberry Pi]: http://www.raspberry-pi-geek.de/Magazin/2014/05/Heimautomation-mit-dem-Raspberry-Pi
[Adding 433 to your Raspberry Pi]: http://shop.ninjablocks.com/blogs/how-to/7506204-adding-433-to-your-raspberry-pi

## You want to start right now? ##

Have a look at the following documentation to start:

* [Software installation](share/doc/software-installation.md)
* [Hardware installation](share/doc/hardware-installation.md)

## What's a PDU anyhow? ##

See the [Wikipedia article].

[Wikipedia article]: https://en.wikipedia.org/wiki/Power_distribution_unit

## Why do I need one? ##

My main use case for PDUs is remote control for computers without excessive standby power usage. For example a Sun Enterprise 250 with active RSC remote control draws at least 10 W of power non-operating. And as the remote control is driven by the standby power of the PSU(s) you need to provide power to the machine for it to work. To solve this issue I use a power outlet of a PDU to provide power when needed only. This way in between power is only drawn by the PDU and any controlling devices but not by the machine itself. Scale this to dozens of machines and you see the savings of electrical power. This of course comes for a price: The more advanced remote control functionality of some machines is really provided by smaller machines, which itself need to exercise self checks on startup and boot a sort of OS, before ready for operation. Hence it takes some time after power was provided to a machine until it can be controlled remotely with this method.

## What are the advantages of a PiPDU over an off-the-shelf PDU? ##

* It's cheap. You stay way below 100 € with e.g. a Raspberry Pi, a 433 MHz transmitter, some cabling and six power outlets. Off-the-shelf PDUs are much more expensive, even used ones except you're lucky.

* As a PiPDU is based on a Raspberry Pi and free software, you can enhance and extend a PiPDU in any ways possible. You want your power outlets to switch regularly or at defined dates and times? Just use _cron_ and _at_.

* Because the power outlets of a PiPDU are radio controlled you have a "perfect" galvanic isolation between the controller and the controlled power outlets and devices. If something bad happens in a power outlet your controller is untouched. This is also an advantage over the use of extension boards with controllable power relays directly attached to your Raspberry Pi, even if the extension board uses optocouplers between the controlling lines and the control coils of the relays.

## Good to know ##

* **Security:** Please be aware of the fact that power outlets with 433 MHz receivers do not have any form of access control apart from reacting on their specific _house/system code_ and _unit code_ combination only. I.e. you just need to know the specific code combination to activate or deactivate a specific power outlet. To make things worse, this combination is transmitted unencrypted over an insecure channel and can be easily recorded and decoded with off-the-shelf 433 MHz receivers and appropriate software. The operating distance for successful radio operation is also quite long (25 m), i.e. it might be possible to control the power outlets from the other side of the street or the neighbour's house.
> **NOTICE:** To weaken this issue somewhat, you could think of sending multiple unused code combinations one after another and "mix in" your real code combination at a random position. You also need to make sure that the real code combination looks random, too, e.g. by always sending the same unused code combinations with the real code combination but in random order, as otherwise you have random code combinations and recurring code combinations which is suspicious. But there's nothing to prevent the replay of all recorded combinations. I.e. it's just useless.

* **Assurance:** Because there is no back channel, there is no possibility for a power outlet to signal successful operation.

* **Electrical hazard:** Depending on the power outlets used, the connectors are only free of power when removed from the power socket. This is due to the usage of relays with one controllable contact only. And as [Schuko] connectors can be inserted in both directions it's undefined which contact provides electrical power. I.e. DO NOT TOUCH ANY OPEN NON PROTECTIVE EARTH CONTACTS OF A POWER OUTLET THAT IS INSERTED IN A POWER SOCKET!

* **Switching power:** Switching power can be limited to less then the 3.6 kW (i.e. 16 A at 230 V~ in Germany) possible on Schuko power sockets. E.g. the radio controllable power outlets I used for the PiPDU prototye (from [Pollin] \[de\]) are limited to 1 kW (4.35 A at 230 V~). Hence before use first check the maximum power ratings of the devices you plan to attach to the power outlets of your PiPDU.

[Schuko]: https://en.wikipedia.org/wiki/Schuko
[Pollin]: http://www.pollin.de/shop/dt/MzMzOTQ0OTk-/Haustechnik_Sicherheitstechnik/Hausautomation/Funksteckdosen/Funksteckdosen_Set_mit_3_Steckdosen.html

## License ##

(GPLv3)

Copyright (C) 2016 Frank Scheiner

The software is distributed under the terms of the GNU General Public License

This software is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a [copy] of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

[copy]: /COPYING

