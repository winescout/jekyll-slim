# Jekyll-slim

[![Gem Version](https://badge.fury.io/rb/jekyll-slim.png)](http://badge.fury.io/rb/jekyll-slim) [![Dependency Status](https://gemnasium.com/kaishin/jekyll-slim.png)](https://gemnasium.com/kaishin/jekyll-slim) [![Code Climate](https://codeclimate.com/github/kaishin/jekyll-slim.png)](https://codeclimate.com/github/kaishin/jekyll-slim) [![Build Status](https://travis-ci.org/kaishin/jekyll-slim.png)](https://travis-ci.org/kaishin/jekyll-slim)

A gem that adds [slim-lang](http://slim-lang.com) support to [Jekyll](http://github.com/mojombo/jekyll). Works for for pages, includes and layouts.

## Installation

Add this line to your Gemfile:

    gem 'jekyll-slim'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-slim

In your Jekyll project's `_plugins` directory:

    # _plugins/bundler.rb
    require 'rubygems'
    require 'bundler/setup'
    Bundler.require(:default)

## Usage

The gem will convert all the `.slim` files in your project's directory into HTML. That includes files in sub-directories, includes and layouts. Example:

```slim
# _layouts/default.slim
html
  head
  body
    .content-wrapper
      | {{ content }}
```
To include a partial, use the `slim` liquid tag instead of `include`:

```slim
# index.slim
---
layout: default
---

section.content Content goes here.
| {% slim footer.slim %}

```

### Options

Is possible to set options available for Slim engine through the `slim` key in `_config.yml`. Example:

```yaml
# _config.yml
slim:
  pretty: true
  format: html5
```

### Context

~~The slim context is now set to the jekyll config object (version 0.8.4)~~.  
**From version 0.9.0 is set to acess a `SlimContext` object which has a `site` method, used to access `config`. Be careful because this is a breaking change.**  
This allows you to access configuration information in your slim file. Example:

```slim
html
  head
  body
    .content-wrapper
      = "slim pretty mode: #{ site.config['slim']['pretty'].to_s }"
```

As of 0.9.0, the SlimContext object will be kept across calls, allowing you to easily set
`@instance_variables` that can be accessed by **all slim files** even those included with the `slim`
liquid tag. Those are more or less global variables in slim templates, so be careful when you use them.

## TODO

- Per-page slim context?
- Improve code and try to avoid patches as much as possible
- Parsing Liquid tags before slim so you have access to everything? Can create a lot of problems with Ruby
- Slim context must be the same as liquid, with paginator, site, page and content variables. See these links:
  - https://github.com/mojombo/jekyll/blob/a9e2a74ea619a01a9d169da2240ce91b43362c9f/lib/jekyll/tags/include.rb
  - https://github.com/mojombo/jekyll/blob/a9e2a74ea619a01a9d169da2240ce91b43362c9f/lib/jekyll/page.rb
  - http://jekyllrb.com/docs/plugins/
  - http://jekyllrb.com/docs/variables/

## Credit

Jekyll-slim was heavily inspired by [jekyll-haml](https://github.com/samvincent/jekyll-haml). It is free software, and may be redistributed under the terms specified in the LICENSE file.

