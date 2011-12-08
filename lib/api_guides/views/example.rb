# -*- encoding: utf-8 -*-

module ApiGuides
  module Views
    class Example
      include MarkdownHelper

      def initialize(example)
        @example = example
      end

      def content
        markdown @example.content
      end
    end
  end
end
