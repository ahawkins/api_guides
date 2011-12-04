require "nokogiri"
require "mustache"
require "i18n"
require "active_support/core_ext/string"
require "api_guides/version"
require "api_guides/markdown_helper"
require "api_guides/document"
require "api_guides/example"
require "api_guides/generator"
require "api_guides/page"
require "api_guides/section"

module ApiGuides
  def self.generate(attributes)
    Generator.new(attributes).generate
  end
end
