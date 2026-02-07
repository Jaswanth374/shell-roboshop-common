#!/bin/bash

source ./common.sh
appname=cart

check_root
create_systemuser
app_code_install
nodejs
systemd_setup