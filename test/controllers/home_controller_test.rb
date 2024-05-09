require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should get index' do
    @admin = create(:admin, email: 'sutta-group@bsv.net.au')
    sign_in @admin
    get home_index_url
    assert_response :success
  end
end
