require_relative  '../poolLadder'

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.app = Sinatra::Application