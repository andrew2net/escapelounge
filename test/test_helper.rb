ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'paperclip/matchers'
require 'minitest/autorun'

class ActiveSupport::TestCase
  extend Paperclip::Shoulda::Matchers
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def file_data(name)
    File.read(Rails.root.to_s + "/test/support/files/#{name}")
  end
end
