require 'spec_helper'

describe ApiGuides::Views::Section do
  include ApiGuides::MarkdownHelper

  let(:reference) { double('Reference') }
  let(:example) { double('Example') }

  let(:section) do
    double('Section', 
           :title => 'A Title', 
           :docs => 'content',
           :reference => reference,
           :examples => [example])
  end

  subject { described_class.new section}

  its(:title) { should == section.title }

  its(:id) { should == 's-a-title' }

  its(:docs) { should == markdown(section.docs) }

  its(:reference) { should be_a(ApiGuides::Views::Reference) }

  its(:examples) { should be_a(Array) }
end
