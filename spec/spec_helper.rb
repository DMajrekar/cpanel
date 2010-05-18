require 'lib/cpanel'

require 'spec/autorun'
require 'webmock/rspec'

include WebMock

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
