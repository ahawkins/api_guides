require 'spec_helper'

describe ApiGuides::Views::Document do
  include ApiGuides::MarkdownHelper

  let(:document) { double('Document', :title => 'A Title', :sections => []) }

  subject { described_class.new document }

  its(:title) { should == document.title }

  its(:id) { should == 'd-a-title' }

  its(:sections) { should be_a(Array) }
end
