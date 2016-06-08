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

########################################################################
# DEFINES
########################################################################

readonly __GLOBAL__version="0.2.0"

# following "/usr/include/sysexits.h"

# EX_OK
readonly __GLOBAL__EX_OK=0

# EX_SOFTWARE
# internal software error not related to OS
readonly __GLOBAL__EX_SOFTWARE=70

# own exit code(s)
readonly __GLOBAL__EX_TIMEOUT=2


########################################################################
# EXTERNAL FUNCTIONALITY
########################################################################

# load common PiPDU functionality
if [[ -e "/usr/share/pipdu/pipdu.bashlib" ]]; then

	. "/usr/share/pipdu/pipdu.bashlib" || exit $__GLOBAL__EX_SOFTWARE
else
	. "$( dirname $BASH_SOURCE )/../share/pipdu/pipdu.bashlib" || exit $__GLOBAL__EX_SOFTWARE
fi


########################################################################
# FUNCTIONS
########################################################################

piPduSh/help()
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

echo "Welcome to the PiPDU $_piPduName"
piPduSh/help

while [[ 1 ]]; do

	read -e -p "${_piPduShellPrompt}" -t $_piPduShellTimeout _command _outlet _ignore

	if [[ $? -ne 0 ]]; then

		echo -e "\nTimeout reached. Exiting."
		exit $__GLOBAL__EX_TIMEOUT
	fi

	case "$_command" in

	on)
		piPdu/on $_outlet
		;;
			
	off)
		piPdu/off $_outlet
		;;

	help)
		piPduSh/help
		;;

	quit)
		echo "Good bye."
		exit $__GLOBAL__EX_OK
		;;
	esac
done

exit

