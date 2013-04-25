#! /bin/bash

curl -o ../../latest_collectrbot.dump `heroku pgbackups:url`