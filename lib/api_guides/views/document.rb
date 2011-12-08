module ApiGuides
  module Views
    class Document
      include ViewHelper

      def initialize(document)
        @document = document
      end

      def id
        anchorize "d-#{@document.title}"
      end

      def title
        @document.title
      end

      def sections
        @document.sections.map { |s| Section.new(s) }
      end
    end
  end
end
