require 'spec_helper'

describe ApiGuides::Views::Example do
  include ApiGuides::MarkdownHelper

  let(:example) { double('Example', :content => 'content') }

  subject { described_class.new example }

  its(:content) { should == markdown(example.content) }
end
