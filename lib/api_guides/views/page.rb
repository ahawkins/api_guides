# -*- encoding: utf-8 -*-

module ApiGuides
  # Represents a HTML page that can be generated using Mustache.
  class Page < ::Mustache
    self.template_file = "#{File.expand_path('../../', __FILE__)}/templates/page.mustache"

    attr_accessor :title, :logo, :documents
  end
end
