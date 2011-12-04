module ApiGuides
  # This class is simply a structure to hold the docs
  # and the examples.
  #
  # Sections require docs, but do not require
  # any examples. Set examples when you want
  # those on the right side of the docs.
  #
  # You never interact with this class directly.
  class Section
    attr_accessor :docs
    attr_accessor :examples
  end
end
