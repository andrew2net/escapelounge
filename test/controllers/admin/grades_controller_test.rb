require 'test_helper'

class Admin::GradesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @grade = grades(:one)
    sign_in users :one
  end

  test "should get index" do
    get admin_grades_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_grade_url
    assert_response :success
  end

  test "should create grade" do
    assert_difference('Grade.count') do
      post admin_grades_url, params: { grade: { name: "Test" } }
    end

    assert_redirected_to admin_grades_url
  end

  test "should get edit" do
    get edit_admin_grade_url(@grade)
    assert_response :success
  end

  test "should update grade" do
    patch admin_grade_url(@grade), params: { grade: { name: "Test" } }
    assert_redirected_to admin_grades_url
  end

  test "should destroy grade" do
    assert_difference('Grade.count', -1) do
      delete admin_grade_url(@grade)
    end

    assert_redirected_to admin_grades_url
  end
end
