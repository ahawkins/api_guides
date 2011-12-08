require 'spec_helper'

describe ApiGuides::Generator do
  before(:each) do
    File.open RSpec.support_path.join("test_guide.xml"), "w" do |file|
      file.puts %Q{
        <document>
          <title>Using ApiGuides</title>
          <position>1</position>
          <section title="The Generator">
            <docs>Docs</docs>
            <reference title="Method Signature">Foobar</reference>
            <examples>
              <example language="ruby">ruby examples</example>
              <example language="python">python examples</example>
            </examples>
          </section>
        </document>
      }
    end
  end

  before(:each) do
    ApiGuides::Generator.new({
      :site_path => RSpec.tmp_path,
      :source_path => RSpec.support_path,
      :title => 'Test Guides',
      :default => 'ruby'
    }).generate
  end

  it "should generate a ruby file" do
    File.exists?(RSpec.tmp_path.join("ruby.html")).should be_true
  end

  it "should generate a python file" do
    File.exists?(RSpec.tmp_path.join("python.html")).should be_true
  end

  it "should copy over the main css" do
    File.exists?(RSpec.tmp_path.join("style.css")).should be_true
  end

  it "should copy over the syntax css" do
    File.exists?(RSpec.tmp_path.join("syntax.css")).should be_true
  end
end
