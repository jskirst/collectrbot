#! /bin/bash

pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d collectrbot_development ../../latest_collectrbot.dump