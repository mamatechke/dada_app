require "test_helper"

class Web::ContentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get web_contents_index_url
    assert_response :success
  end

  test "should get show" do
    get web_contents_show_url
    assert_response :success
  end
end
