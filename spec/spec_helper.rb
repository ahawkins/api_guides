$: << File.expand_path("../../lib", __FILE__)

require 'simplecov'
SimpleCov.start

require 'api_guides'
require 'pathname'

module RSpec
  def self.support_path
    Pathname.new "#{File.dirname(__FILE__)}/support"
  end

  def self.tmp_path
    Pathname.new "#{File.dirname(__FILE__)}/tmp"
  end
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.fail_fast = true

  config.before :each do
    FileUtils.rm_rf RSpec.support_path.join("*")
    FileUtils.rm_rf RSpec.tmp_path.join("*")
  end
end

