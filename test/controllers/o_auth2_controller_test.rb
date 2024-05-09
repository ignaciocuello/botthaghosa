require 'test_helper'

class OAuth2ControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = create(:admin, email: 'sutta-group@bsv.net.au')
    sign_in @admin
  end

  test 'authorize redirects when credentials missing' do
    Google::Auth::WebUserAuthorizer.any_instance
                                   .expects(:get_credentials)
                                   .with(@admin.to_param, anything)
                                   .returns(nil)
    get authorize_path
    assert_response :redirect
  end

  test 'authorize renders when credentials present' do
    credentials = Google::Auth::UserRefreshCredentials.new
    credentials
      .expects(:needs_access_token?)
      .returns(false)
    Google::Auth::WebUserAuthorizer.any_instance
                                   .expects(:get_credentials)
                                   .with(@admin.to_param, anything)
                                   .returns(credentials)

    get authorize_path
    assert_response :success
    assert_select 'h1', 'Authorized!'
  end
end
