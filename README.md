# Hotpages

__Hotpages is currently in pre-release. It likely has many bugs, but if you're interested, please give it a try. [Send feedback here](https://github.com/koedasha/hotpages/issues/new)__

Static web site authoring with Ruby.

Hotpages is a static site generator that uses Ruby. It is especially recommended if you hand-write HTML while building your site and want to keep your HTML DRY (Don't Repeat Yourself) using Ruby.

## Features

- Directory-based routing
- Helper functions similar to Rails’ ActionView
- ERB as the primary template language, with many others available via [Tilt](https://github.com/jeremyevans/tilt)
- Default support for [Hotwire](https://hotwired.dev) (Turbo, Stimulus)
- Comfortable authoring with a development server that supports hot reloading
- Additionally, features such as i18n, asset cache invalidation, detection of broken internal links, template path annotations, and inline SVG are built-in as standard for convenient static site building.

## Installation

Hotpages requires [Ruby](https://www.ruby-lang.org/) 3.4 or later and [bundler](https://bundler.io).

If you use rbenv to install Ruby, refer to [Installing rbenv](https://github.com/rbenv/rbenv#installation) and [Installing Ruby versions](https://github.com/rbenv/rbenv#installing-ruby-versions).

Run the following command to verify Ruby is installed correctly. If it looks OK, proceed.

```bash
ruby -v # OK if it shows version ruby 3.4 or later
```

Once Ruby is installed, install bundler. After both Ruby and bundler are installed, proceed.

```bash
gem install bundler
```

The Hotpages gem is not yet published to a registry, so clone the Git repository and install from it as follows:

```bash
git clone https://github.com/koedasha/hotpages.git
```

## Get Started

In the directory where you cloned the repository, run the following command to create a new Hotpages site. Replace `YOUR_NEW_SITE_NAME` with your new site’s name.

```bash
hotpages/exe/hotpages new YOUR_NEW_SITE_NAME
```

Start the development server for the new site with:

```bash
cd YOUR_NEW_SITE_NAME
bundle install
bin/dev
```

Open `http://localhost:4000` in your browser. If you see `Hello, hotpages!`, you’re all set!

Finally, generate the static site by running:

```bash
bin/gen
```

By default, the output is written to the `_site` directory in the current directory.

## Edit Web Pages

Continuing from “Get Started,” open `pages/index.html.erb` under `site` directory in your editor. You should see `<%= greeting %>` in the file. `greeting` is a simple Ruby method defined in `pages/index.rb`.

Try changing the return value of the `greeting` method in `pages/index.rb`. Thanks to the hot reloading freature of development server, the text shown in your browser should update immediately.

The basic approach is to place template files and Ruby files that handle their data under the `pages` directory to define web pages. You can freely organize files under `pages`.

This directory structure directly becomes the structure of the pages in the generated site.

Each Ruby file defines a subclass of the `Page` class described in `shared/page.rb`. By modifying this `Page` class, you can provide methods common to all pages.

### Ways to Define Pages

#### Pages without Ruby

A template alone will be compiled into a web page. If you don’t need a Ruby file, you don’t have to create one.

#### Pages with Ruby only

If you define a `body` method in the Ruby file, its return value is evaluated as ERB and compiled into the page’s HTML.

#### Directory-wide shared Ruby file

If you want a shared Ruby file within a directory, place `_page.rb` in that directory. Its contents are applied to all templates in that directory.

### Ignored files under `pages`

Files placed under `pages` whose names start with an underscore (`_`) are ignored and not compiled into web pages.

### Path expansion

Directories and page files whose names start with a colon, such as `:slug.html.erb`, are treated as expandable paths. The expansion names are taken from the return value of the `self.segment_names` method defined in a Ruby file with the same basename (without the extension) in the same directory, such as `:slug.rb`. For example, if `self.segment_names` in `:slug.rb` returns an array like `["one", "two"]`, then `:slug.html.erb` will generate two HTML files: `one.html` and `two.html`.

In this case, the expanded segment string, such as `one` or `two`, is stored in the `segments` hash within the page file. If the page filename is `:slug.html.erb`, you can access it as `segments[:slug]`.

## Partial rendering

Use the `render` method to render partials while passing local variables, for example `render "shared/post", post: post`. You can place partials under the `pages` directory and specify the partial file from a page using a relative path. In this case, the partial filename must begin with an underscore (`_`); see Ignored files under `pages`.

## Directories in `site` Overview

- `pages`
  - The most important directory. Place the page files described above.
- `models`
  - Place model files. By calling models from page Ruby, you can author web pages with a workflow similar to building an MVC application.
- `data`
  - Place data files to be used by models. Intended for CSV, Markdown, etc.
- `helpers`
  - Place helper modules callable from pages. Helper functions are available globally within pages.
- `layouts`
  - Place layout files. From page Ruby, use `layout "layout_file_name"` to change the layout. The default layout file is `site.html.erb`.
- `shared`
  - Place Ruby files and partials shared across pages.
- `assets`
  - Place JavaScript, CSS, and images. By default, `controllers` contains Stimulus controller JS, `css` contains CSS, and `images` contains images.
- `locales`
  - Locale files for i18n. By default, localization uses [FastGettext](https://github.com/grosser/fast_gettext) YAML locale files.

## Templates Other Than ERB

Hotpages supports ERB by default, but any format supported by Tilt should be usable. See [the Tilt README](https://github.com/jeremyevans/tilt#tilt) for supported template engines. To use them with Hotpages, install the necessary library and `require` it in `site.rb`. For example, to render Markdown with [Kramdown](https://kramdown.gettalong.org):

```bash
bundle add kramdown
```

```ruby
# site.rb
require "kramdown"
```

This enables handling template files and partials like `pages/index.html.md` (the topmost extension of the template file must indicate the output file format).

There are many template engines supported by Tilt, so not all have been tested. If you encounter issues with a template you use, please send [feedback](https://github.com/koedasha/hotpages/issues/new).

## Websites Built with Hotpages

- [Koeda-sha's Website](https://koeda.jp)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/koedasha/hotpages. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/koedasha/hotpages/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [ISC License](https://opensource.org/license/isc).

## Code of Conduct

Everyone interacting in the GemTemplate project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/koedasha/hotpages/blob/main/CODE_OF_CONDUCT.md).
