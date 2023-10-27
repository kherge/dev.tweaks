#!/bin/sh

# Exit on error.
set -e

# Configure debconf to be non-interactive.
export DEBIAN_FRONTEND=noninteractive

# Make sure that require dependencies are available.
install_packages()
{
  if ! dpkg -s "$@" > /dev/null; then
    echo "Installing missing packages..."

    apt-get update
    apt-get install --no-install-recommends -y "$@"
  fi
}

install_packages curl unzip

# Download sh.env.
echo "Downloading sh.env..."

curl -L -o main.zip https://github.com/kherge/sh.env/archive/refs/heads/main.zip

# Install sh.env.
echo "Installing sh.env..."

unzip main.zip -d .
mv ./sh.env-main/ /opt/sh.env
rm main.zip

# List options to activate on first login.
INIT="$_REMOTE_USER_HOME/.options"

if [ "$_LS" != '' ]; then
  echo 'option -e ls' >> "$INIT"
fi

if [ "$_PATH" != '' ]; then
  echo 'option -e path' >> "$INIT"
fi

if [ "$_PS1" != '' ]; then
  echo 'option -e ps1' >> "$INIT"
fi

if [ "$_SDKMAN" != '' ]; then
  echo 'option -e sdkman' >> "$INIT"
fi

if [ "$_VAR" != '' ]; then
  echo 'option -e var' >> "$INIT"
fi

if [ -f "$INIT" ]; then
  echo "rm \"$INIT\"" >> "$INIT"
fi

# Modify the shell profile to load the customization.
echo "Modifying /etc/profile..."

echo >> /etc/profile
echo '# loading shell customizations' >> /etc/profile
echo '. /opt/sh.env/env.sh /opt/sh.env' >> /etc/profile
echo '[ -f .options ] && . .options' >> /etc/profile
