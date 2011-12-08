# -*- encoding: utf-8 -*-

module ApiGuides
  # This class models an example for your documentation.
  # It is for a specific language and contains a raw
  # markdown formatted string. A diffrent version of the documentation
  # will be generated for each language with examples.
  #
  # You never interact with this class directly.
  class Example
    attr_accessor :language
    attr_accessor :content

    def initialize(attributes = {})
      attributes.each_pair do |attr, value|
        send "#{attr}=", value
      end
    end

    # Takes an XML representation and parse
    # it into an Example instance. 
    # 
    # Here is XML format expected:
    #
    #     <examle language="Foo">
    #       <![CDATA[
    #       Insert your markdown here
    #       ]]>
    #     </reference>
    #
    # This would set `#language` to 'Foo'
    # and #content to 'Insert your markdown here'
    def self.from_xml(xml)
      doc = Nokogiri::XML.parse(xml).at_xpath('//example')
      Example.new :language => doc.attributes['language'].try(:value), :content => doc.content
    end
  end
end
