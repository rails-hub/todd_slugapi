require 'test_helper'

class FriendshipControllerTest < ActionController::TestCase

  test "inviting a friend creates new object and accepting makes it active" do
   
    u = User.first
    u2 = User.last

    assert_difference('Friendship.count') do
      post(:invite_friend_api, auth_token: u.auth_token, search_term: u2.username)
    end

    friendship = Friendship.where('user_id=? AND friend_id=?', u.id, u2.id).limit(1)[0]
    assert_not friendship.accepted, "Friendship should not have been accepted already"

    # Check that friendship was successfully accepted
    post(:accept_invite_api, auth_token: u2.auth_token, friend_id: u.id)
    friendship = Friendship.where('user_id=? AND friend_id=?', u.id, u2.id).limit(1)[0]
    assert friendship.accepted==true, "Friendship should now have been accepted"

    post(:get_friends_api, auth_token: u.auth_token)
    assert_not json_response[0].nil?, "Expected an array with at least 1 friend"
    assert_not (json_response[0]['username'].nil?), "get_friends should've resulted in at least 1 friend with a username, but it did not"
   
    puts "User #{u.username} requested friends and found #{json_response[0]['username']} in the list"
    puts json_response
    puts 'our id: '+u.id.to_s
    assert_not (json_response[0]['id']==u.id), "get_friends should not return the requesting user's own id"

    assert (json_response[0]['auth_token'].nil?), "get_friends should not be returning auth_token fields, but it is."
    assert (json_response[0]['password'].nil?), "get_friends should not be returning password fields, but it is."

  end

  test "require auth_token" do
    post(:invite_friend_api)
    assert json_response['errors'].include?('logged out'), "invite_friend should have required an auth token"    

    post(:get_friends_api)
    puts 'get friends response:'
    assert json_response['errors'].include?('logged out'), "get_friends_api should have required an auth token"    

    post(:accept_invite_api)
    assert json_response['errors'].include?('logged out'), "accept_invite_api should have required an auth token"    
  end


end
