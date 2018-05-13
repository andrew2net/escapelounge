# frozen_string_literal: true

require 'test_helper'

class GamesHistoryControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users :two
    sign_in @user
  end

  test 'should get index' do
    get games_history_path
    assert_response :success
  end
end
