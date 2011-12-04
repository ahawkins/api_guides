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
  #     |- ruby_examples.html
  #     |- phython_examples.html
  #     |- objective_c_examples.html
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
    def intialize(attributes = {})
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
    # and uses their sections to create the HTML.
    #
    # Documents are rendered in the order specified `#position`.
    def generate
      # Parse all the documents specified recusively in the `source_path`
      documents = Dir["#{source_path}/**/*.xml"].map do |path|
        Document.new(path)
      end

      documents = documents.sort {|d1, d2| d1.position <=> d2.position }

      # Now collect all the different languages
      languages = documents.collect { examples.map { |ex| ex.language }}.compact.uniq

      # Use the list of languages to parse the document's sections of code
      # and examples into tuples. We can pass that off to a mustache template
      # for rendering. Then we can store the contents to file. We need to repeat
      # this process for each language.

      languages.map do |language|
        tuples = documents.collect(&:sections).inject([]) do |tuples, section|
          tuple = Tuple.new

          tuple.docs = left_align section.docs

          example = section.examples.select {|ex| ex.language == language }.first
          tuple.code = left_align(example.content) if example
        end

        page = Page.new
        page.title = title
        page.logo = logo
        page.tuples = tuples

        File.open("#{site_path}/#{language.underscore}_html") do |file|
          file.puts page.render
        end
      end


      # Copy the stylesheet into the site directory
      resources_path = File.expand_path "../resources", __FILE__

      FileUtils.cp "#{resources_path}/style.css", "#{site_path}/style.css"

      # Copy the logo if specified
      FileUtils.cp "#{logo}", "#{site_path}/#{File.basename(logo)}"

      # copy the default language to the index and were done!
      FileUtils.cp "#{site_path}/#{default.underscore}", "#{site_path}/index.html"
    end

    private 
    class Tuple
      attr_accessor :docs, :code
    end
  end
end
