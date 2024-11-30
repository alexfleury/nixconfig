#!/usr/bin/env bash

rclone bisync protondrive: ~/Data/ProtonDrive --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case