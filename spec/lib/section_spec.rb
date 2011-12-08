require 'spec_helper'

describe ApiGuides::Section do
  describe ".from_xml" do
    let(:xml) do
      %Q{
        <section title="Foo">
          <docs>docs</docs>
          <reference title="Bar">
            <![CDATA[
            Insert your markdown here
            ]]>
          </reference>
          <examples>
            <example language="ruby">
              <![CDATA[
              Insert your markdown here>
              ]]>
            </example>
          </example>
        </section>
      }
    end

    let(:example) { double('Example') }
    let(:reference) { double('Reference') }

    before(:each) do
      ApiGuides::Example.should_receive(:from_xml).and_return(example) 
      ApiGuides::Reference.should_receive(:from_xml).and_return(reference) 
    end

    subject { ApiGuides::Section.from_xml(xml) }

    its(:title) { should == 'Foo' }

    its(:docs) { should == 'docs' }

    its(:examples) { should == [example] }

    its(:reference) { should == reference }
  end

  describe "#initialize" do
    it "should set the title if given" do
      section = ApiGuides::Section.new :title => 'Foo'
      section.title.should == 'Foo'
    end

    it "should set the docs if given" do
      section = ApiGuides::Section.new :docs => 'Foo'
      section.docs.should == 'Foo'
    end

    it "should set the reference if given" do
      section = ApiGuides::Section.new :reference => 'reference'
      section.reference.should == 'reference'
    end

    it "should set the examples if given" do
      section = ApiGuides::Section.new :examples => []
      section.examples.should == []
    end
  end
end
