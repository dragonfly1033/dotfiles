#!/bin/bash

sudo vmhgfs-fuse .host:/pics /mnt/hgfs/shared -o allow_other -o uid=1000
