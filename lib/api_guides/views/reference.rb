# -*- encoding: utf-8 -*-

module ApiGuides
  module Views
    class Reference
      include MarkdownHelper
      include ViewHelper

      def initialize(reference)
        @reference = reference
      end

      def id
        anchorize "r-#{@reference.title}"
      end

      def title
        @reference.title
      end

      def content
        markdown @reference.content
      end
    end
  end
end
