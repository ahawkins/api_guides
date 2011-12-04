require 'spec_helper'

describe ApiGuides::Generator do
  before(:each) do
    File.open Rspec.support_path.join("support/test_guide.xml"), "w" do |file|
      file.puts %Q{
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
      }
    end
  end

  subject do
    ApiGuides::Generator.new({
      :site_path => RSpec.tmp_path,
      :source_path => RSpec.suppor_path,
      :title => 'Test Guides',
      :default => 'ruby'
    }).generate
  end

  it "should generate a ruby file" do
    File.should exists(RSpec.support_path.join("ruby_examples.html"))
  end

  it "should generate a python file" do
    File.should exists(RSpec.support_path.join("python_examples.html"))
  end
end
