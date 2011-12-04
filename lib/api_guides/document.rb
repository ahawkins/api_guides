module ApiGuides
  # The document class models the raw information in each guide.
  # The document is parsed according to this format:
  #
  #     <document>
  #       <title>Top Level Header</title>
  #       <position>1<>
  #       <section>
  #         <docs>
  #           Insert your markdown here
  #         </docs>
  #         <examples>
  #           <example language="ruby"><![CDATA[
  #             Insert your markdown here.
  #
  #             You can use github fenced codeblocks to create syntax 
  #             highlighting like this:
  #
  #             ```ruby
  #             # note you don't have to indent!
  #             def method_name(arg)
  #               # do stuff
  #             end
  #             ```
  #
  #             You can also specify code like you would in normal markdown
  #             by indenting by 2 tabs or 4 spaces:
  #
  #                 // here is an example data structure
  #                 {
  #                   "foo": "bar"
  #                 }
  #
  #             **Note!** All content will be automatically left 
  #             aligned so you can indent your markup to make 
  #             it easier to read. 
  #           ]]></example>
  #           <example language="javascript"><![CDATA[
  #             Insert more markdown here
  #           ]]></example>
  #         </examples>
  #       </section>
  #     </document>
  #
  #
  #  **Important**: Be sure to wrap your text tags with `<![CDATA[ ]]>` otherwise
  #  the file may not parse correctly since it may not be valid XML.
  #
  # `title` element names this section of the guide.
  #
  # `position` element determines the order to render the document. 
  # This allows you to have multiple documents in any structure you want.
  #
  # You can have has many sections as you want. You should only have one 
  # <doc> block. You can have have <examples> if you want. There can be
  # as many <example>'s inside if you want. Another copy of the site will
  # be generated for each language. 
  #
  # The markdown is parsed [Github Markdown](http://github.github.com/github-flavored-markdown/).
  # Code is highlighted using [pygments](http://pygments.org/).
  #
  # This class parses the table of contents for each document into a TableOfContents instance.
  # It also parses an array of Section instances. The Generator uses this information
  # to generate the final files.
  #
  # You may choose to indent your tags or not. All content will be
  # left-aligned so code and other indentation senstive markdown will be
  # parsed correctly.
  class Document
    # Creates a document from an absolute file name.
    # Here is an example:
    #
    #     ApiGuides::Document.new "/absolute/path/to/file.xml"
    #
    # You should never interact with this class directly though.
    def initialize(source_file)
      @source = source_file
    end

    # Returns the title based from the <title> element
    def title
      xml.at_xpath('/document/title').content
    end

    # Returns the position from the <position> element
    def position
      xml.at_xpath('/document/position').content.to_i
    end

    # Parses the document into a table of contents based
    # on headers. Sections do not affect this at all.
    # Here is an example of a markdown document with the generated
    # table of contents:
    #
    #     <section>
    #       # Top Level Header
    #
    #       ## Second Level Header
    #
    #       ## Another Header
    #     </section>
    #     <section>
    #       ## More information
    #
    #       ### A subsection
    #     </section>
    #
    # Would generate this TOC:
    #
    #     1. Top Level Header
    #       1.1. Second Level Header
    #       1.2. Another Header
    #       1.3. More Information
    #         1.3.1 A subsection
    #
    # Everything will be grouped under the top level header specified
    # in the `<title>` element.
    #
    # The table of contents is used by the generator to assemble the index
    # with links to the apporiate sections.
    #
    # It will only generate links up to H3 elements. H4, H5, H6 elements
    # are simply ignored.
    def table_of_contents

    end

    # Parses the document according to the <section> tags
    # with the documents and examples.
    #
    # The sections are used by the generator to assemble the final document.
    # They are rendered serially.
    def sections
      xml.xpath('//section').inject([]) do |memo, element|
        section = Section.new
        section.docs = element.at_xpath('./docs').content

        section.examples = element.xpath('./examples/example').inject([]) do |exs, example_element|
          example = Example.new
          example.language = example_element.attributes['language'].value
          example.content = example_element.content
          exs << example
          exs
        end

        memo << section
        memo
      end
    end

    private
    def xml
      @xml ||= Nokogiri::XML.parse(@source.respond_to?(:read) ? @source.read : File.read(@source))
    end
  end
end
