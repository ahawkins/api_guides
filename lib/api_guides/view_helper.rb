# -*- encoding: utf-8 -*-

module ApiGuides
  module ViewHelper
    # AKA permalink
    def anchorize(text)
      text.gsub(/[^\w-]/, ' ').gsub(/\s+/, '-').downcase
    end
  end
end
