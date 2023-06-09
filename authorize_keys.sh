#!/bin/sh
touch /home/user/.ssh/authorized_keys
chown user /home/user/.ssh -R
chgrp user /home/user/.ssh -R
