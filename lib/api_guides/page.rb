module ApiGuides
  # Represents a HTML page that can be generated using Mustache.
  class Page < ::Mustache
    self.template_path = File.expand_path "../resources/page.mustache", __FILE__

    attr_accessor :tile, :logo, :tuples, :table_of_contents
  end
end
