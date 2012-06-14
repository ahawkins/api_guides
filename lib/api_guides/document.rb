# -*- encoding: utf-8 -*-

module ApiGuides
  # The document class models the raw information in each guide.
  #
  # The document is parsed according to this format:
  #
  #     <document>
  #       <title>Top Level Header</title>
  #       <position>1<>
  #       <section title="Level Two Header">
  #         <docs>
  #           Insert your markdown here
  #         </docs>
  #         <reference title="Example1">
  #           A Reference element will always be shown with the associated section.
  #           You should use this area to provide technical documentation
  #           for each section. You could use the <docs>'s element to
  #           describe how each thing works, and use the reference to show
  #           a method signature with return values.
  #
  #           Write your reference with markdown.
  #
  #           You can use standard markdown syntax plus 
  #           helpers added by this library
  #         </reference>
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
    attr_accessor :title, :position, :sections

    def initialize(attributes = {})
      attributes.each_pair do |attr, value|
        send "#{attr}=", value
      end
    end

    # Takes XML and parses into into a Document
    # instance. It wil also parse the section
    # using its `from_xml` method.
    def self.from_xml(xml)
      doc = Nokogiri::XML.parse(xml).at_xpath('//document')
      document = Document.new :title => doc.at_xpath('./title').try(:content), 
        :position => doc.at_xpath('./position').try(:content).try(:to_i)

      document.sections = doc.xpath('//section').map {|section_xml| Section.from_xml(section_xml.to_s) }

      document
    end
  end
end
