# -*- encoding: utf-8 -*-

require 'redcarpet'
require 'net/http'

module ApiGuides
  module MarkdownHelper
    class HTMLwithHighlighting < ::Redcarpet::Render::HTML
      # Override the default so we can do syntax highlighting
      # based on the language
      def block_code(code, language)
        # If there's a language, use the pygments webservice
        # to highlight for the language
        if language
          Net::HTTP.post_form(
            URI.parse('http://pygments.appspot.com/'),
            {'lang' => language, 'code' => code}
          ).body

        # fallback to standar
        else
          super(code, language)
        end
      end
    end

    # Simple helper to convert a string to markdown using
    # all our custom hax (including syntax highligting).
    # It uses Redcarpert to do the heavy lifting.
    def markdown(string)
      content = left_align string

      md = ::Redcarpet::Markdown.new HTMLwithHighlighting, :auto_link => true, 
        :no_intra_emphis => true,
        :tables => true, 
        :fenced_code_blocks => true,
        :strikethrough => true

      md.render content
    end

    # Takes a string and removes trailing whitespace from the
    # beginning of each line. It takes the number of leading whitespace
    # characters from the first line and removes that from every single
    # line in the string. It's used to normalize strings that may be
    # intended when writing the XML documents.
    def left_align(string)
      return string unless string.match(/^(\s+)\S/)

      lines = string.gsub("\t", "  ").lines

      first_line = lines.select {|l| l.present?}.first

      leading_white_space = first_line.match(/^(\s+)\S/)[1].length

      aligned_string = lines.map do |line|
        line.gsub(/^\s{#{leading_white_space}}/, '')
      end.join('')
    end
  end
end
