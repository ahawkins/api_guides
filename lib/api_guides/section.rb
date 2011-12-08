module ApiGuides
  # This class is simply a structure to hold the docs
  # and the examples.
  #
  # Sections require docs, but do not require
  # any examples. Set examples when you want
  # those on the right side of the docs.
  #
  # You never interact with this class directly.
  class Section
    attr_accessor :docs, :examples, :reference, :title

    def initialize(attributes = {})
      attributes.each_pair do |attr, value|
        send "#{attr}=", value
      end
    end

    # Takes an XML representation and parse
    # it into a section instance. 
    # 
    # Here is XML format expected:
    #
    #     <section title="Foo">
    #       <docs>
    #         <![CDATA[
    #         Insert your markdown here
    #         ]]>
    #       </docs>
    #       <reference title="Bar">
    #         <![CDATA[
    #         Insert your markdown here
    #         ]]>
    #       </reference>
    #       <examples>
    #         <example language="ruby">
    #           <![CDATA[
    #           Insert your markdown here>
    #           ]]>
    #         </example>
    #       </example>
    #     </section>
    #
    # It also loops instantiates the Reference
    # and examples if they are given using their
    # `from_xml` methods as well
    def self.from_xml(xml)
      doc = Nokogiri::XML.parse(xml).at_xpath('//section')
      section = Section.new :title => doc.attributes['title'].try(:value)
      section.docs = doc.at_xpath('./docs').content

      if reference_xml = doc.at_xpath('./reference')
        section.reference = Reference.from_xml(reference_xml.to_s)
      end

      section.examples = doc.xpath('//example').map do |example_xml|
        Example.from_xml example_xml.to_s
      end

      section
    end
  end
end
