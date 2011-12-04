require 'spec_helper'

describe ApiGuides::Document do
  let(:xml) do
    StringIO.new(%Q{
      <document>
        <title>Tests</title>
        <position>1</position>
        <section>
          <docs>Docs</docs>
          <examples>
            <example language="ruby">ruby examples</example>
            <example language="python">python examples</example>
          </examples>
        </section>
      </document>
    })
  end

  subject { ApiGuides::Document.new(xml) }

  its(:title) { should == 'Tests' }

  its(:position) { should == 1 }

  describe "#sections" do
    it "should load all the sections" do
      subject.sections.length.should == 1
    end

    it "should have a ruby example" do
      example = subject.sections.first.examples.first

      example.language.should == 'ruby'
      example.content.should == 'ruby examples'
    end

    it "should have a python example" do
      example = subject.sections.first.examples[1]

      example.language.should == 'python'
      example.content.should == 'python examples'
    end
  end
end
