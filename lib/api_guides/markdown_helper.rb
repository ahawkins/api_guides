module ApiGuides
  module MarkdownHelper
    def markdown(string)
      left_align string
    end

    # Takes a string and removes trailing whitespace from the
    # beginning of each line. It takes the number of leading whitespace
    # characters from the first line and removes that from every single
    # line in the string. It's used to normalize strings that may be
    # intended when writing the XML documents.
    def left_align(string)
      lines = string.gsub("\t", "  ").lines

      first_line = lines.select {|l| l.present?}.first

      leading_white_space = first_line.match(/(\s+)\S/)[1].length

      aligned_string = lines.map do |line|
        line.gsub(/^\s{#{leading_white_space}}/, '')
      end.join('')
    end
  end
end
