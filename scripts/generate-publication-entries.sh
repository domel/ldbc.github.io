#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

find ./bibs/ -iname "*bib" \
    -exec ~/.local/bin/academic import \
        --overwrite \
        --publication-dir=content/english/publication \
        --verbose \
        --bibtex {} \
    \;
