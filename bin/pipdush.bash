#!/bin/bash

# PiPDUShell

:<<COPYRIGHT

Copyright (C) 2016 Frank Scheiner

The program is distributed under the terms of the GNU General Public License

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

COPYRIGHT

. /etc/pipdush.conf

########################################################################
# VARIABLES
########################################################################

__GLOBAL__numberOfOutlets=${#_piPduOutlets[@]}
__GLOBAL__piPduSendCommand="/usr/bin/rf433send"


########################################################################
# FUNCTIONS
########################################################################

piPdu/validOutletGiven()
{
	local _outlet="$1"

	# check if value of _outlet is an integer number. Please notice that we use single brackets!
	if ! [ "$_outlet" -eq "$_outlet" ] 2>/dev/null; then

		echo "No valid outlet given. Valid outlet values are integer values from 1 to $__GLOBAL__numberOfOutlets."
		return 1
	fi

	if [[ $_outlet -gt $__GLOBAL__numberOfOutlets || \
	      $_outlet -lt 1 || \
	      $_outlet == "" ]] ; then

		echo "No valid outlet given. Valid outlet values are integer values from 1 to $__GLOBAL__numberOfOutlets."
		return 1
	else
		return 0
	fi
}


piPdu/on()
{
	local _outlet="$1"
	local _systemCode=""
	local _unitCode=""
	local _index=""

	if piPdu/validOutletGiven "$_outlet"; then

		echo "Powering on outlet \"$_outlet\"."

		_index=$(( $_outlet - 1 ))
		_systemCode=$( echo "${_piPduOutlets[$_index]}" | cut -d ';' -f 1 )
		_unitCode=$( echo "${_piPduOutlets[$_index]}" | cut -d ';' -f 2 )

		"$__GLOBAL__piPduSendCommand" -u -b "$_systemCode" "$_unitCode" 1 &>/dev/null
		return
	else

		return 1
	fi
}


piPdu/off()
{
	local _outlet="$1"
	local _systemCode=""
	local _unitCode=""
	local _index=""

	if piPdu/validOutletGiven "$_outlet"; then
	
		echo "Powering off outlet \"$_outlet\"."

		_index=$(( $_outlet - 1 ))
		_systemCode=$( echo "${_piPduOutlets[$_index]}" | cut -d ';' -f 1 )
		_unitCode=$( echo "${_piPduOutlets[$_index]}" | cut -d ';' -f 2 )

		"$__GLOBAL__piPduSendCommand" -u -b "$_systemCode" "$_unitCode" 0 &>/dev/null
		return
	else
		return 1
	fi
}


piPdu/help()
{
	echo "Valid commands are:"
	echo "* on <OUTLET>"
	echo "* off <OUTLET>"
	echo "* help"
	echo "* quit"
	return
}


########################################################################
# MAIN
########################################################################

trap ':' SIGINT

if [[ ! -e "$__GLOBAL__piPduSendCommand" ]]; then

	echo "The \`$__GLOBAL__piPduSendCommand\` command couldn't be found. Please check the requirements in INSTALL.md and provide the \`$__GLOBAL__piPduSendCommand\` command before retrying. Exiting now." 1>&2
	exit 1
fi

# Make GPIO pin 17 accessible in user mode by the calling user
gpio export 17 out

echo "Welcome to the PiPDU $_piPduName"
piPdu/help

while [[ 1 ]]; do

	#echo -n "$_piPduShellPrompt"
	read -e -p "${_piPduShellPrompt}" -t $_piPduShellTimeout _command _outlet _ignore

	if [[ $? -ne 0 ]]; then

		echo -e "\nTimeout reached. Exiting."
		exit 2
	fi

	case "$_command" in

	on)
		piPdu/on $_outlet
		;;
			
	off)
		piPdu/off $_outlet
		;;

	help)
		piPdu/help
		;;

	quit)
		echo "Good bye."
		exit
		;;
	esac
done

exit

