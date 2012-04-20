# API Guides

**Example (and primary use case)**:
[http://developer.radiumcrm.com](http://developer.radiumcrm.com)

`ApiGuides` is a simple static generator based off Docco. It is
specifically designed to handle writing documentation for HTTP APIs,
however it should be flexible enough to work in many other situations as
well. The generator will create HTML, CSS, and an optional logo image inside
a directory. You can deploy the site using any web server or Heroku if
you like.

You should use this generator if you need want to create documenation
with these things in mind:

1. You want to write in Markdown.
2. You want syntax highlighting for a variety of langauges.
3. You want an automatic table of contents
4. You want an index of all the technical information
5. You want to provide examples of using your code in one or more
   different languages or frameworks.
6. You want to structure your documentation between different code
   repos or separate files.
7. You want to link to specific sections of documentation from within
   other sections of documentation.
8. You have **a lot** of documentation to write. This generator also works
   well with small about of documentation as well.
9. You want something that looks pretty and is easy to read, and you don't 
   want to make any CSS decisions or worry about presentational issues.

If you think most of those things sound good then read on.

## Structuring Documentation

Raw documenation is kept in XML files with content written in Markdown.
I've chosen XML because it is great at storing and organizing large
amounts of text. Don't worry, you won't have to mess with XML that much.

You can (and should) structure your documenation in separate files. You
can think of each file has a chapter in your documentation. You may have
one file that generally describes your program and a file for each
feature.

A document is composed of sections. A section is composed of textual
content written in markdown, a reference written in markdown, and zero,
one, or more examples written in markdown. Here is an example document.

```xml
<document>
  <title>introduction</title>
  <position>1</position>
  <section title="about">
    <docs>
      <![cdata[
      # write your markdown here
      ]>
    </docs>
    <reference title="about">
      <![cdata[
      # write some stuff describing your "about" interface
      ]]>
    </reference>
    <examples>
      <example language="ruby">
        <![cdata[
        # write some markdown for your ruby example
        ]]>
      </example>
      <example language="python">
        <![cdata[
        # write some markdown for your python example
        ]]>
      </example>
    </examples>
  </section>
</document>
```

There is a lot to take in from that example so let's break it down!

### The document Element

Is the root element and must contain a `title`, `position` and one or
more `sections`. A `<document>` signifys a new chapter of your
documentation. The `title` will be placed in a `h1` and subsequent
section titles will be placed in `<h2>`s. The `<position>` element
determines the order.

### The section Element

Sections are a way to group textual documentation, examples, and
technical documentation. You can give a `<section>` a `title` attribute.
This will create a TOC entry under the parent `<document>`'s `<title>`.
You can omit `title` if you do not want a header or TOC entry generated.
You usually skip this for the first section since most of the time you
don't want a header right under another without any text in between. You
may include `<examples>` or `<reference>` if you wish, but you should
always include `<docs>`. The examples and reference material will always
be shown with the associated docs. You can omit `<docs>` but that
doesn't make any sense! Who's going to figure out what they're doing
without the docs?

### The reference Element

The Reference element contains technical documentation for the
associated docs. It may be a method signature or whatever you can think
of. The reference will always be shown with the associated docs and with
any examples. You may also give the `<reference>` a `title` attribute.
`<references>` with a `title` attribute will be included in the index.
You may omit the `title` if you do not want this to be indexed. You
should always include a reference!

### The example Element

Examples contain code for the language or framework specified in the
`language` attribute. An example will always be shown with the reference
and associated docs. You can `omit` the language if you want. If you do,
the example will be shown for **all** different languages. 
You can write whatever you want for the content. It
can be text, lists, as well as code. The generator makes no assumption
about what will be in the example, just that it will be markdown. A
different version of the documentation will be generated for each
language specified in your documents.

### General Output

Your docs will always be shown on the left. If a reference is present, it
will be shown exactly opposite of the docs. If examples are present,
they will be shown below the reference.

### Generating the Table of Contents

A TOC will be generated according to `<title>` elements inside the
`<document>` and `title` attributes on the `<section>` element. Here are
some example XML documents and generated table of contents.

```xml
<document>
  <title>Introduction</title>
  <position>1</position>
  <section>
    <docs>Foo</docs>
  </section>
  <section title="Overview">
    <docs>Bar</docs>
  </section>
  <section title="Response Codes">
    <docs>Bar</docs>
  </section>
</document>
```

```xml
<document>
  <title>Response Codes</title>
  <position>2</position>
  <section title="Success">
    <docs>Foo</docs>
  </section>
  <section title="Redirection">
    <docs>Bar</docs>
  </section>
  <section title="Failure">
    <docs>Bar</docs>
  </section>
</document>
```

1. Introduction
  1. Overview
  2. Reponse Codes
2. Rreponse Codes
  1. Success
  2. Redirection
  3. Failure

## Markdown

I love Markdown. It's much easier to read and write than textile.
[Redcarpet](https://github.com/tanoku/redcarpet) is used for parsing. It includes some more features like
fenced code blocks with language specification (yay!), tables, and a few
other tricks. You can read their documentation for the complete list of
available features. You may also include HTML inside the markdown, but
you cannot use markdown inside the HTML. A common use case for
HTML is `<dl>`. Definition lists are part of PHP markdown extra and not
supported by Redcarpet.

[Pygments](http://pygments.org/) is used for syntax highlighting. The generator uses the
pygments webservice so you don't have to worry about installing anything
python related on your machine. It supports a very large variety of
different languages and the generator includes a theme to make all of
them look nice and pretty.

## Linking

You can also link to sections, documents, or references throughout your
documentation. Each element will be given an ID that you can use to
create an anchor link for. They are prefaced with `d`, `s` or `r`
depending on what they are. This is to prevent duplication. The titles
are are dasherized aka permalinks. Here are some examples:

1. `<section title="Introduction and about">` -->
   "s-introduction-and-about"
2. `<reference title="Logging In">` --> "r-logging-in"
3. `<title>Messages: SMS, Email, & IM</title>` -->
   "d-messages-sms-email-im"

## Installation and Use

First thing you'll need to do is install Ruby. I'm assuming you already
have this installed or know how to install for your operating system.
After that, you can simply install the gem.

```
gem install api_guides
```

The easiest way to generate the docs is from a rake task. Here is an
example. Assume your directory sturcture is like this:

```
|- source/
---------| guide1.xml
---------| guide2.xml
---------| guide3.xml
|- site/
|- Rakefile
```

Here is an example Rakefile:

```ruby
require 'bundler'
require 'api_guides'

task :generate do
  ApiGuides::Generator.new({
    :source_path => "#{File.dirname(__FILE__)}/source",
    :site_path => "#{File.dirname(__FILE__)}/site",
    :title => 'Cool API',
    :logo => "#{File.dirname(__FILE__)}/logo.png",
    :default => "ruby"
  }).generate
end

task :default => :generate
```

When ever you update your guides just run:

```bash
$ bundle exec rake
```

This will stick all the generated files into `site/`. 
**Note**: Always deal with absolute paths for certanity.
**WARNING**: The contents of `site_path` will be deleted before
generation occurs. Don't put anything in there if you want to keep it.

### Options

The `ApiGuides::Generator` constructor takes a few options. Here are the
details.

* `:source_path`: Abosolute path to the directory containing all the XML
  documents.
* `:site_path`: Absolute path for the generated files
* `:title`: It goes in the navbar and the `<title>` in the finished HTML
* `:default`: Required if there is more than one language. This sets
  the examples on the index page.
* `:logo`: _Optional_. Absolute path to an image to put in the navbar.

## Deploying

Since the generated documentation is just static HTML, CSS, and images
we can deploy to any web server very easily. This section shows you how
to write a simple [Rack](http://rack.rubyforge.org/) server so you can deploy it to Heroku.

First, create `config.ru` file in your directory. Here are the contents:

```ruby
require 'rack-rewrite'

use Rack::Rewrite do
  rewrite '/', '/index.html'
end

root = "#{Dir.pwd}/site"
run Rack::Directory.new("#{root}")
```

Make sure you update the `root =` line with whatever directory holds all
the files.

You can test it locally by running these commands:

```bash
$ gem install rack rack-rewrite
$ rackup -p 3000
```
Now open `http://localhost:3000` and you should see your documentation.

Now, create a `Procfile` so heroku knows how to start your application:

```yml
web: bundle exec rackup -p $PORT
```

Now you're ready to deploy your documentation!

```bash
$ bundle exec rake # to generate the documentation if you haven't yet
$ git init
$ git add -A
$ git commit -m 'Update documentation'
$ heroku create --stack cedar
$ git push heroku master
$ heroku open
```

## Credits

* [Docco](http://jashkenas.github.com/docco/) - For creating the original style. CSS taken from source
  with some modifications.
* [Stripe](https://stripe.com/docs/api) - For inspiring more complex documentation and layout.
  Although, I think this came out better!
* [Rocco](https://github.com/rtomayko/rocco) - For demonstrating how to use Mustache
* [Twitter Boostrap](http://twitter.github.com/bootstrap) - For the navbar. I only took what I needed and
  repackaged them into the `#topbar` selector.

## Hacking

Feel free to hack on the code in your own fork. Send me a pull request
if you do cool stuff.

## Documentation

Documentation is written for Rocco. You can read the annotated source
[here](http://threadedlabs.github.com/api_guides).

## License

MIT.
