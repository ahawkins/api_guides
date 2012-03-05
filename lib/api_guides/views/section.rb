# -*- encoding: utf-8 -*-

module ApiGuides
  module Views
    class Section
      include MarkdownHelper
      include ViewHelper

      def initialize(section)
        @section = section
      end

      def id
        anchorize "s-#{@section.title}"
      end

      def title
        @section.title
      end

      def docs
        markdown @section.docs if @section.docs
      end

      def reference
        if @section.reference
          Reference.new @section.reference
        else
          nil
        end
      end

      def examples
        (@section.examples || []).map {|ex| Example.new ex }
      end
    end
  end
end
