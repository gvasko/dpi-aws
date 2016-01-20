#!/bin/bash

### AWS Main Script

# Set scriptdir
if [ "x${0:0:1}" = 'x/' ]; then
	scriptdir=`dirname "$0"`
else
	scriptdir=`dirname "$PWD/$0"`
fi

if [ "$#" -lt 2 ]; then
	echo "Error in arguments."
	echo "Usage: $0 <domain> <subcommand> [<arguments>]"
	echo "Example: $0 admin up ..."
	echo "Example: $0 admin destroy ..."
	echo "Example: $0 stack up ..."
	echo "Example: $0 stack destroy ..."
	exit 1
fi

domain=$1

subcommand=$2

shift
shift

domain_dir="$scriptdir/disposable/$domain"
subcommand_file="$domain_dir/$domain-$subcommand.sh"

if [ ! -d "$domain_dir" ]; then
	echo "ERROR: domain '$domain' not supported."
	echo "Supported domains: $(ls $scriptdir/disposable | tr '\n' ' ')"
	echo
	exit 1
fi

if [ ! -f "$subcommand_file" ]; then
	echo "ERROR: subcommand '$subcommand' not supported."
	supported_subcommands=$(cd $domain_dir; ls $domain-*.sh | tr '\n' ' ' | sed "s:$domain-::g" | sed "s:\.sh::g")
	echo "Supported subcommands in domain '$domain': $supported_subcommands"
	echo
	exit 1
fi
	
echo "Invoking: $subcommand_file $*"

$subcommand_file $*

echo
