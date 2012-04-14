require 'spec_helper'

class StringAligner
  include ApiGuides::MarkdownHelper
end

describe StringAligner do
  let(:indented_string) do
    %Q{
      # This String is intended in the source

      Its lines are underneath it.

      It may have some code too like this:

          def this_method(arg)
            puts arg
          end

      There may also be intended lists!

        * Value
        * Value
          * Value

      This should shift it all to the left and align
      all lines with the leading line
    }
  end

  let(:aligned_string) do
    %Q{
# This String is intended in the source

Its lines are underneath it.

It may have some code too like this:

    def this_method(arg)
      puts arg
    end

There may also be intended lists!

  * Value
  * Value
    * Value

This should shift it all to the left and align
all lines with the leading line
    }
  end

  it "should align the string" do
    subject.left_align(indented_string).should == aligned_string
  end

  it "should handle an unaligne string" do
    subject.left_align(aligned_string).should == aligned_string
  end
end
