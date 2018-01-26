#!/bin/bash
## sets up the docs environment to serve mkdocs-built site

pushd $(dirname $0) > /dev/null

cd $(pwd -P)/..
DOCS_ROOT=`cd ./doc/mkdocs && pwd -P`

if [ -z `command -v cpio` ] ; then
    echo "cpio command is not available, please install it" && popd > /dev/null && exit 1
fi

find . \( -path "./doc/mkdocs" -o -path './vendor' \) -prune -o -type f -regex ".+\.\(md\|png\|jpg\|svg|json\)$" -print | cpio -p -dum --quiet $DOCS_ROOT/docs

popd > /dev/null
