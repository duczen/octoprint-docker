#!/bin/sh

# Make octoprint data writeable as non-root user
mkdir -p /home/octoprint/.octoprint
chown -R octoprint:octoprint /home/octoprint

# Start octoprint
sudo -u octoprint octoprint serve

