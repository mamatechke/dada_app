require "test_helper"

class Web::CirclesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get web_circles_index_url
    assert_response :success
  end

  test "should get show" do
    get web_circles_show_url
    assert_response :success
  end
end
