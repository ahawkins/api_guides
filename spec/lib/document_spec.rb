require 'spec_helper'

describe ApiGuides::Document do
  describe ".from_xml" do
    let(:xml) do
      %Q{
        <document>
          <title>Foo</title>
          <position>1</position>
          <section title="Bar">
            <docs>Docs</docs>
            <reference title="Baz">Reference content</reference>
            <examples>
              <example language="ruby">ruby examples</example>
              <example language="python">python examples</example>
            </examples>
          </section>
        </document>
      }
    end

    let(:section) { double('Section') }

    before(:each) do
      ApiGuides::Section.should_receive(:from_xml).and_return(section) 
    end

    subject { ApiGuides::Document.from_xml(xml) }

    its(:title) { should == 'Foo' }

    its(:position) { should == 1 }

    its(:sections) { should == [section] }
  end

  describe "#initialize" do
    it "should set the position if given" do
      document = ApiGuides::Document.new :position => 1
      document.position.should == 1
    end

    it "should set the title if given" do
      document = ApiGuides::Document.new :title => 'Foo'
      document.title.should == 'Foo'
    end

    it "should set the sections if given" do
      document = ApiGuides::Document.new :sections => []
      document.sections.should == []
    end
  end
end
