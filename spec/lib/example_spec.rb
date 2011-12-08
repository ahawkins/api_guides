require 'spec_helper'

describe ApiGuides::Example do
  describe ".from_xml" do
    let(:xml) { %Q{<example language="ruby">bar</example>} }

    subject { ApiGuides::Example.from_xml(xml) }

    its(:language) { should == 'ruby' }

    its(:content) { should == 'bar' }
  end

  describe "#initialize" do
    it "should set the language if given" do
      example = ApiGuides::Example.new :language => 'Foo'
      example.language.should == 'Foo'
    end

    it "should set the content if given" do
      example = ApiGuides::Example.new :content => 'Foo'
      example.content.should == 'Foo'
    end
  end
end
