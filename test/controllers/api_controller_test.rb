require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "Token check validates token" do
    post(:token_test)
    puts json_response
    assert_not json_response['errors'].nil?, "API Controller should have checked for auth token, but it didn't"

    u=User.first
    post(:token_test, auth_token: u.auth_token)
    puts json_response
    assert json_response['errors'].nil?, "API Controller didn't accept a valid auth_token"

  end
end
