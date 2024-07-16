#!/bin/sh
touch /home/user/.ssh/authorized_keys
chown 1000 /home/user/.ssh -R
chgrp 1000 /home/user/.ssh -R
