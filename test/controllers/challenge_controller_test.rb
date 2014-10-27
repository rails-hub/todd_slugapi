require 'test_helper'

class ChallengeControllerTest < ActionController::TestCase

  test "Challenging creates challenges" do
    u=User.first
    u2=User.last
    assert_not u.nil?
    assert_not u2.nil?
    assert_not u.id==u2.id

    assert_difference('Challenge.count') do
      post(:challenge_player, auth_token: u.auth_token, player_id: u2.id)
    end

    assert_response :success

    assert_not json_response[0].nil?, "Expected at least one challenge to come back in response"
    puts json_response
    challenge_verified = false
    json_response.each do |ch|
      if(ch['challenger_id']==u.id && ch['challengee_id']==u2.id)
        challenge_verified = true
      end
    end

    assert challenge_verified, "Challenge was not successfully created."

    #assert json_response['errors'].nil?, "Errors exist where a challenge should have been created"
    #assert_not json_response['challengee_id'].nil?, "Challengee came back nil"
  end

  test "Getting challenges list returns challenges" do
    u=User.first
    u2=User.last
    assert_not u.nil?
    assert_not u2.nil?
    assert_not u.id==u2.id

    # Create a challenge
    assert_difference('Challenge.count') do
      u.challenge u2
    end

    post(:get_challenges, auth_token: u.auth_token)

    assert_response :success

    found_challenge = false
    json_response.each do |ch|
      if(ch['challenger_id']==u.id && ch['challengee_id']==u2.id)
        found_challenge = true
      end
    end

    assert found_challenge, "Could not find challenge we just created"
  end

  test "require auth_token" do
    post(:get_challenges)
    assert json_response['errors'].include?('logged out'), "get_challenges should have required an auth token"    

    post(:challenge_player)
    assert json_response['errors'].include?('logged out'), "challenge_player should have required an auth token"    
  end
  

end
