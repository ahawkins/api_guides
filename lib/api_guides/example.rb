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
  end
end
