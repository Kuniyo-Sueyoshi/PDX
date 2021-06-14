#!/bin/sh

# unzip
for file in *.gz; do
    gunzip $file
done

# rename
find ./ -type f -name "GSE159702_*" | sed 'p;s/GSE159702_//' | xargs -n 2 mv
