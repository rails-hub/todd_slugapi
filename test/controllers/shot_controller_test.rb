require 'test_helper'

class ShotControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "require auth_token" do
    post(:get_shots_api)
    assert json_response['errors'].include?('logged out'), "get_shots_api should have required an auth token"    

    post(:post_shot_api)
    assert json_response['errors'].include?('logged out'), "post_shot_api should have required an auth token"    
  end



end
