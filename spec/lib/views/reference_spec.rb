require 'spec_helper'

describe ApiGuides::Views::Reference do
  include ApiGuides::MarkdownHelper

  let(:reference) { double('Reference', :title => 'A Title', :content => 'content') }

  subject { described_class.new reference }

  its(:title) { should == reference.title }

  its(:id) { should == 'r-a-title' }

  its(:content) { should == markdown(reference.content) }
end
