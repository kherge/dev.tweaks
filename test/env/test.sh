#!/bin/bash

# Exit on error.
set -e

# Load development container testing tools.
source dev-container-features-test-lib

# Load the default profile.
source /etc/profile

# Verify that options are available.
check "activation" option -l | grep 'Available options'

# Print the results.
reportResults
