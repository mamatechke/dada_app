require "test_helper"

class Web::OnboardingControllerTest < ActionDispatch::IntegrationTest
  test "should get step1" do
    get web_onboarding_step1_url
    assert_response :success
  end

  test "should get step2" do
    get web_onboarding_step2_url
    assert_response :success
  end

  test "should get step3" do
    get web_onboarding_step3_url
    assert_response :success
  end

  test "should get step4" do
    get web_onboarding_step4_url
    assert_response :success
  end

  test "should get step5" do
    get web_onboarding_step5_url
    assert_response :success
  end

  test "should get submit" do
    get web_onboarding_submit_url
    assert_response :success
  end
end
