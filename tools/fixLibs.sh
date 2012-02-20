#!/bin/bash
for file in $(find ./usr/i686-pc-mingw32/lib -regex ".+\.a")
do
    echo fixing $file
    ./usr/bin/i686-pc-mingw32-ranlib $file
done
