#!/bin/bash

source ./common.sh
appname=user

check_root
create_systemuser
app_code_install
nodejs
systemd_setup