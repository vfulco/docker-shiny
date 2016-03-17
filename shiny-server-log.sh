#!/bin/sh

exec chpst -u shiny svlogd -tt /var/log/shiny-server/
