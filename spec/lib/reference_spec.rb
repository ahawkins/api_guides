require 'spec_helper'

describe ApiGuides::Reference do
  describe ".from_xml" do
    let(:xml) { %Q{<reference title="Foo">bar</reference>} }

    subject { ApiGuides::Reference.from_xml(xml) }

    its(:title) { should == 'Foo' }

    its(:content) { should == 'bar' }
  end

  describe "#initialize" do
    it "should set the title if given" do
      reference = ApiGuides::Reference.new :title => 'Foo'
      reference.title.should == 'Foo'
    end

    it "should set the content if given" do
      reference = ApiGuides::Reference.new :content => 'Foo'
      reference.content.should == 'Foo'
    end
  end
end
