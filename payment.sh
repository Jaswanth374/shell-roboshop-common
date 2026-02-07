#!/bin/bash

source ./common.sh
appname=payment

check_root
create_systemuser
app_code_install
python_setup
systemd_setup