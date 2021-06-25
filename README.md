# ldbc.github.io

[![](https://github.com/ldbc/ldbc.github.io/workflows/github%20pages/badge.svg)](https://github.com/ldbc/ldbc.github.io/actions)

The website is built using the [Hugo](https://gohugo.io/) site generator. To serve the site without building it under _public/_ at <http://localhost:1313>, run:

```bash
hugo server
```

For detailed build instructions, please consult the [GitHub Actions workflow configuration](.github/workflows/gh-pages.yml).

## Publications

Publications are generated using [`hugo-academic-cli`](https://github.com/wowchemy/hugo-academic-cli). Follow the instructions used in the GitHub Actions configuration.

## Posts

Create a new markdown file with the title as the filename under _content/english/post_ to create a new post. You can use the skeleton in  below to help you fill out post metadata (also include the closing and opening `---` character sequence):
```
---
type: post
title: "{{ replace .Name "-" " " | title }}"
author: 
# optional link to homepage of autor
author_url: 
# short comment shon below author/date
short_comment:
date: {{ .Date }}
tags: ["example tag"]
# please make sure to remove image parameter if unused
image: "post/{{ .Name }}/featured.png" 
---
```

Alternatively, clone the site, get the theme submodule under _themes_, and use the CLI `hugo` tool to conveniently generate the skeleton for a post:
```
hugo new post/my-post.md
```
This command will create the _my-post.md_ under _content/english/post_ with an initial template.

To add any attachment to a post, create a folder **with lowercase name** that matches the name of the post, and all resources in that folder can be referenced from markdown using a relative URL.


## Events

To create a new event, the steps are very similar to that of creating a new post. The markdown header for an event is as follows:
```
---
type: event
title: "{{ replace .Name "-" " " | title }}"
location: 
author: 
# optional link to homepage of autor
author_url: 
# short comment shon below author/date
short_comment:
# page publish date (NOT event date).
publishDate: {{ .Date }}
# make sure to use lower case letters for tags to ensure proper categorization
date: {{ .Date }}
# events that are single-day events, remove date_end
date_end: {{ .Date }}
tags: ["example tag"]
# please make sure to remove image parameter if unused
image: "event/{{ .Name }}/featured.png"
---
```

Alternatively, clone the site, get the theme submodule under _themes_, and use the CLI `hugo` tool to conveniently generate the skeleton for an event:
```
hugo new event/Meeting-Event.md
```
This command will create the Meeting-Event.md_ file under _content/english/event_ with an initial template.


## Serving the page locally

```bash
hugo server
```

Note that you will need to clone the theme submodule in the _themes_ folder to get the site 100% up and running.
