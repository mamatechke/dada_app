require "test_helper"

class Web::ThemePreviewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get web_theme_preview_index_url
    assert_response :success
  end
end
