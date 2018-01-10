#!/usr/bin/env bash
if [ -f /picomto-init-complete ]; # The entrypoint script touches this file
then # Ping server to see if it is ready
  exit 0 #TODO
else # Initialization still in progress
  exit 1
fi
