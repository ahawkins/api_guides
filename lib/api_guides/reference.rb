module ApiGuides
  # This class models a <reference> element in a document.
  # It will always be shown with the associated section.
  # All references will be combined into an index.
  #
  # References can also be linked to using standard
  # markdown syntax with some sugar provided by this
  # library.
  #
  # Each reference has a title. The title is used for linking
  # and descirbing each reference. You should markdown
  # inside each reference to fill in your content
  class Reference
    attr_accessor :title, :content

    def initialize(attributes = {})
      attributes.each_pair do |attr, value|
        send "#{attr}=", value
      end
    end

    # Takes an XML representation and parse
    # it into a Reference instance. 
    # 
    # Here is XML format expected:
    #
    #     <reference title="Foo">
    #       <![CDATA[
    #       Insert your markdown here
    #       ]]>
    #     </reference>
    #
    # This would set `#title` to 'Foo'
    # and #content to 'Insert your markdown here'
    def self.from_xml(xml)
      doc = Nokogiri::XML.parse(xml).at_xpath('//reference')
      Reference.new :title => doc.attributes['title'].try(:value), :content => doc.content
    end
  end
end
