#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

# hack: use the 'subtitle' field to pass the Internet Archive URL through the academic CLI script
sed -i.bkp 's/ia_url/subtitle/' ./bibs/*.bib
find ./bibs/ -iname "*bib" \
    -exec academic import \
        --overwrite \
        --publication-dir=content/english/publication \
        --verbose \
        --bibtex {} \
    \;
rm ./bibs/*.bib.bkp
