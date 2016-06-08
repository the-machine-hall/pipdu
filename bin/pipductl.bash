#!/bin/bash

# PiPDU control

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

readonly __GLOBAL__program="pipductl"
readonly __GLOBAL__version="0.1.0"

# following "/usr/include/sysexits.h"

# EX_OK
readonly __GLOBAL__EX_OK=0

# EX_USAGE
# e.g. wrong usage of program (wrong number of arguments, wrong flags, etc)
readonly __GLOBAL__EX_USAGE=64

# EX_SOFTWARE
# internal software error not related to OS
readonly __GLOBAL__EX_SOFTWARE=70


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

piPduCtl/usageMsg()
{
	echo "Usage: $__GLOBAL__program --on, --off <OUTLET>"

	return
}


piPduCtl/helpMsg()
{
	echo "Usage: $__GLOBAL__program --on, --off <OUTLET>"

	return
}


piPduCtl/invalidOption()
{
	local _invalidOption="$1"

	echo "$__GLOBAL__program: invalid option -- '$_invalidOption'" 1>&2
	echo "Try '$__GLOBAL__program --help' for more information." 1>&2

	return
}


########################################################################
# MAIN
########################################################################

# correct number of params?
if [[ $# -lt 1 ]]; then

	# no, so output a usage message
	piPduCtl/usageMsg
	exit $__GLOBAL__EX_USAGE
fi

while [[ "$1" != "" ]]; do

	# only valid options used?
	if [[ "$1" != "--help" && \
	      "$1" != "--version" && "$1" != "-V" && \
	      "$1" != "--on" && "$1" != "-1" && \
	      "$1" != "--off" && "$1" != "-0" \
	]]; then

		_option="$1"
		piPduCtl/invalidOption "$_option"
		exit $__GLOBAL__EX_USAGE
	fi

	# process options
	# "--help"
	if [[ "$1" == "--help" ]]; then

		piPduCtl/helpMsg
		exit $__GLOBAL__EX_OK

	# "--on, -1"
	elif [[ "$1" == "--on" || "$1" == "-1" ]]; then

		_option="$1"

		shift 1
		#  next positional parameter an option or an option parameter?
		if [[ ! "$1" =~ ^-.* && "$1" != "" ]]; then

			_outlet="$1"

			piPdu/on "$_outlet"
			exit
		else
			echo "$__GLOBAL__program: Missing argument for option \"$_option\"!" 1>&2
			piPduCtl/usageMsg
			exit $__GLOBAL__EX_USAGE
		fi

	# "--on, -1"
	elif [[ "$1" == "--off" || "$1" == "-0" ]]; then

		_option="$1"

		shift 1
		#  next positional parameter an option or an option parameter?
		if [[ ! "$1" =~ ^-.* && "$1" != "" ]]; then

			_outlet="$1"

			piPdu/off "$_outlet"
			exit
		else
			echo "$__GLOBAL__program: Missing argument for option \"$_option\"!" 1>&2
			piPduCtl/usageMsg
			exit $__GLOBAL__EX_USAGE
		fi
	fi
done

exit

