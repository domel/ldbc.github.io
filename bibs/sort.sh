#!/bin/bash

biber --tool --configfile=sort.conf references.bib
mv references_bibertool.bib references.bib

