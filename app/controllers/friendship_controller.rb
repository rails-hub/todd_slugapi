class FriendshipController < ApiController
  skip_before_filter :verify_authenticity_token

  def get_friends_api
    json @logged_user.friends
  end

  def get_pending_api
    json @logged_user.pending_friends
  end

  def accept_friend_api
    friendship = Friendship.find_by_friend_id_and_user_id(@logged_user.id, invite_params[:friend_id])
    if params[:type] == "yes"
      result = accept_friend friendship
    elsif params[:type] == "no"
      result = reject_friend_api friendship
    end
  end

  def accept_friend friendship
    if friendship.blank?
      error 'Friendship not found'
      return
    else
      friendship.update(:accepted => true)
      user = User.find_by_id(friendship.friend_id)
      PushController.push_message_to_user "#{@logged_user.username} has accepted your friendship on Slug Buggy", user
    end
    json friendship

  end

  def reject_friend_api friendship
    friendship = Friendship.find_by_friend_id_and_user_id(@logged_user.id, invite_params[:friend_id])
    if friendship.blank?
      error 'Friendship not found'
      return
    else
      begin
        friendship.destroy!
      rescue Exception => exc
        error "Something went wrong."
        return
      end
    end
    success "Friendship request rejected successfully."
  end

  def invite_friend_api
    friend = User.find_by_email(params[:search_term].downcase)
    friend = User.find_by_username(params[:search_term].downcase) unless !friend.nil?
    friend = User.find_by_phone(params[:search_term].downcase) unless !friend.nil?

    if !friend.nil?

      if (friend.id==@logged_user.id)
        error "You can't invite yourself."
        return
      end

      begin
        @logged_user.invite_friend friend
      rescue ActiveRecord::RecordNotUnique
        error "You already have invited this user to play."
        return
      end
    else
      error "User #{params[:search_term].downcase} not found."
      return
    end
    get @logged_user.friends
  end

  def accept_invite_api
    puts "ids: #{@logged_user.id} - #{invite_params[:friend_id]}"
    friendship = Friendship.where(:user_id => invite_params[:friend_id], :friend_id => @logged_user.id)[0]
    puts "Find friendship where user id is #{invite_params[:friend_id]} and friend id is #{@logged_user.id}"

    if friendship.nil?
      error 'Friendship not found'
      return
    else
      friendship.accepted = true
      friendship.save!
    end
    json friendship
  end

  def invite_params
    params.permit(:friend_id, :user_id, :type)
  end

end
