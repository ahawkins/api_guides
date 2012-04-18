# -*- encoding: utf-8 -*-

require 'fileutils'

module ApiGuides
  # The generator creates a static html document for each different
  # language you have examples for. You only ever interact
  # with the Generator. It scans the specified directory for XML
  # files and parses them into Documents. It then uses the documents
  # to create the HTML file.
  #
  # The output is directly inspired by [Stripe](https://stripe.com/docs/api)
  # (which is Docco inspired). We mix it with a hint of Twitter bootstrap
  # and *poof!* We have documentation.
  #
  # The Generator only needs to know 4 things.
  #
  # 1. The absolute path to the folder containing all the XML files.
  # 2. The absolute path to the folder to generate the static site.
  # 3. What language is the default aka which languages go in `index.html`.
  # 4. The site title. This goes in the `<title>` and the top nav bar.
  #
  # You may also configure the generator with a logo which will be copied
  # into the site directory.
  #
  # The generator creates a static site following this structure:
  #
  #     /
  #     |- sytle.css
  #     |- logo.png
  #     |- index.html
  #     |- ruby.html
  #     |- phython.html
  #     |- objective_c.html
  #
  # Once you have the site you can use any webserver you want to serve it up!
  #
  # You can refer to Readme for an example of serving it for free with heroku.
  #
  # You can instantiate a new Generator without any arguments.
  # You should assign the individual configuration options via
  # the accessors. Here is an example:
  #
  #     generator = ApiGuides::Generator.new
  #     generator.source_path = "/path/to/guides/folder"
  #     generator.site_path = "/path/to/site/folder"
  #     generator.default = "json"
  #     generator.title = "Slick API docs"
  #     generator.logo = "/path/to/logo.png"
  #
  #     # whatever else you need to do
  #
  #     generator.generate
  class Generator
    attr_accessor :source_path, :site_path, :default, :title, :logo

    # You can instatiate a new generator by passing a hash of attributes
    # and values. 
    #
    #     Generator.new({
    #       :source_path => File.dir_name(__FILE__) + "/guides"
    #       :site_path => File.dir_name(__FILE__) + "/source"
    #     })
    #
    # You can also omit the hash if you like.
    def initialize(attributes = {})
      attributes.each_pair do |attribute, value|
        self.send("#{attribute}=", value)
      end
    end

    # Parse all the documents and generate the different HTML files.
    #
    # This method will remove `source_path/*` and `site_path/*` to
    # ensure that a clean site is generated each time.
    #
    # It reads all the xml documents according to `source_path/**/*.xml` 
    # and uses them to create the HTML.
    #
    # Documents are rendered in the order specified `#position`.
    def generate
      # Ensure site is a directory
      FileUtils.mkdir_p site_path

      # If there is more than one language, then we need to create
      # multiple files, one for each language.
      if languages.size >= 1

        # Enter the most dastardly loop. 
        # Create a View::Document with sections only containing the 
        # specified language. 
        languages.map do |language|
          document_views = documents.map do |document|
            document.sections = document.sections.map do |section|
              section.examples = section.examples.select {|ex| ex.language.blank? || ex.language == language }
              section
            end

            Views::Document.new document
          end

          # Use Mustache to create the file
          page = Page.new
          page.title = title
          page.logo = File.basename logo if logo
          page.documents = document_views

          File.open("#{site_path}/#{language.underscore}.html", "w") do |file|
            file.puts page.render
          end
        end

        # copy the default language to the index and were done!
        FileUtils.cp "#{site_path}/#{default.underscore}.html", "#{site_path}/index.html"

      # There are no languages specified, so we can just create one page
      # using a collection of Document::View.
      else 
        document_views = documents.map do |document|
          Views::Document.new document
        end

        page = Page.new
        page.title = title
        page.logo = File.basename logo if logo
        page.documents = document_views

        File.open("#{site_path}/index.html", "w") do |file|
          file.puts page.render
        end
      end

      # Copy the logo if specified
      FileUtils.cp "#{logo}", "#{site_path}/#{File.basename(logo)}" if logo

      # Copy all the stylesheets into the static directory and that's it!
      resources_path = File.expand_path "../resources", __FILE__

      FileUtils.cp "#{resources_path}/style.css", "#{site_path}/style.css"
      FileUtils.cp "#{resources_path}/syntax.css", "#{site_path}/syntax.css"
    end

    private
    # Parse and sort all the documents specified recusively in the `source_path`
    def documents
      Dir["#{source_path}/**/*.xml"].map do |path|
        Document.from_xml File.read(path)
      end.sort {|d1, d2| d1.position <=> d2.position }
    end

    # Loop all the document's sections and examples to see all the different
    # languages specified by this document.
    def languages
      @languages ||= documents.collect(&:sections).flatten.collect(&:examples).flatten.map(&:language).compact.uniq
    end
  end
end
