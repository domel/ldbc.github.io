# ldbc.github.io

[![](https://github.com/ldbc/ldbc.github.io/workflows/github%20pages/badge.svg)](https://github.com/ldbc/ldbc.github.io/actions)

For up-to-date build instructions, please consult the [GitHub Actions workflow configuration](.github/workflows/gh-pages.yml).

## Publications

Publications are generated using [`hugo-academic-cli`](https://github.com/wowchemy/hugo-academic-cli):

```bash
pip3 install -U academic
academic import --bibtex publications.bib
```

## Posts

Create a new markdown file with the title as the filename under _content/english/post_ to create a new post. You can use the skeleton below to help you fill out post metadata (also include the closing and opening `+++` character sequence):
```
+++
title: "{{ replace .Name "-" " " | title }}"
subtitle: ""
summary: ""
authors: []
tags: []
categories: []
date: {{ .Date }}
lastmod: {{ .Date }}
featured: false
draft: false
+++
```

Alternatively, clone the site, get the theme submodule under _themes_, and use the CLI `hugo` tool to conveniently generate the skeleton for a post:
```
hugo new post/my-post.md
```
This command will create the _my-post.md_ under _content/english/post_ with an initial template.

