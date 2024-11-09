#!/bin/bash

# Create the new PATH from the directories
for directory in $TOOLCHAINS_DIRECTORY/*/bin; do
	# Add directory to path
	export PATH="$PATH:$directory"
done

# Execute the provided command
exec $@