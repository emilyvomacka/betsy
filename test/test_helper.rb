require 'simplecov'
SimpleCov.start do 
  add_filter "/test/"
  add_filter "/config/"
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(merchant)
    return {
    provider: merchant.provider,
    uid: merchant.uid,
    info: { email: merchant.email, name: merchant.name, nickname: merchant.nickname }}
  end
  
  def perform_login(merchant = nil)
    merchant ||= Merchant.first
    
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
    get auth_callback_path(:github)
    
    return merchant
  end
end
