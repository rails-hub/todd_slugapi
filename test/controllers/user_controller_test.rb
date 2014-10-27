require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "login api responds with errors using incorrect credentials" do
    post(:login_api, username: 'jquave', password: 'an_incorrect_password')
    assert_response :success

    jr = ActiveSupport::JSON.decode @response.body
    assert_not jr['errors'].nil?, "Did not respond to failed login attempt with incorrect password"
  end

  test "login success shows user object" do
    # Set the password so we know it's right
    u=User.first
    pass = 'fdksjfl00ASDf'
    u.password = pass
    u.save!

    post(:login_api, username: u.username, password: pass)
    assert_response :success, "Failure code upon logging in"

    jr = ActiveSupport::JSON.decode @response.body
    assert jr['username']==u.username, "Did not get the same username back"


    
    u = User.first

    post(:login_api, auth_token: jr['auth_token'])
    jr = ActiveSupport::JSON.decode @response.body

    assert jr['username']==u.username, "Did not get username back when signing in using an auth token"




  end

  test "login with auth token returns correct user" do
    u = User.first
    u.password = 'fdklshgslkjghs'
    u.auth_token = "dslkghslgkhsf4309u4f8j"
    u.save!

    post(:login_api, auth_token: u.auth_token)
    jr = ActiveSupport::JSON.decode @response.body

    assert jr['username']==u.username, "Did not get username back when signing in using an auth token"
  end

  test "login with incorrect auth token return errors" do
    u = User.first
    u.password = 'fdskflhsjlkgf'
    u.auth_token = 'dsajflhldsgh'
    u.save!

    post(:login_api, auth_token: '+++')
    jr = ActiveSupport::JSON.decode @response.body

    assert_not jr['errors'].nil?
  end


end
