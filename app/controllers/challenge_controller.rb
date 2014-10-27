class ChallengeController < ApiController
  skip_before_filter :verify_authenticity_token
  before_filter :check_token!

  def accept_challenge
    challenge = Challenge.find_by_challenger_id_and_challengee_id_and_accepted(accept_challenge_params[:challenger_id], @logged_user.id, false)
    if params[:type] == "yes"
      result = accept_challenge_api challenge
    elsif params[:type] == "no"
      result = reject_challenge_api challenge
    end
  end

  def accept_challenge_api challenge
    if challenge.blank?
      error 'Challenge not found'
      return
    else
      challenge.update(:accepted => true)
      user = User.find_by_id(challenge.challenger_id)
      PushController.push_message_to_user "#{@logged_user.username} has accepted your challenge on Slug Buggy", user
    end
    json challenge

  end

  def reject_challenge_api challenge
    if challenge.blank?
      error 'Challenge not found'
      return
    else
      begin
        challenge.destroy!
      rescue Exception => exc
        error "Something went wrong."
        return
      end
    end
    success "Challenge request rejected successfully."
  end

  def quit_challenge_api
    challenge = Challenge.find_by_id_and_accepted(quit_challenge_params[:challenge_id], true)
    unless challenge.blank?
      begin
        challenge_shot = Challenge_Shot.where('user_id = ? AND challenge_id = ?', @logged_user.id, challenge.id)
        challenge_shot.each do |cs|
          cs.destroy!
        end
        challenge.destroy!
        success "Challenge Quit Successfully."
      rescue Exception => exc
        error "Something went wrong."
      end
    else
      error "No such challenge found."
    end
  end

  def get_challenges
    @challenges = @logged_user.challenges
    challenge_details = Hash.new []
    array = []
    @challenges.each do |challenge|
      this_shots = Challenge_Shot.where('user_id = ? AND challenge_id = ?', @logged_user.id, challenge.id)
      that_shots = Challenge_Shot.where('user_id = ? AND challenge_id = ?', challenge.challengee_id == @logged_user.id ? challenge.challenger_id : challenge.challengee_id, challenge.id)
      challenge_hash = {:id => challenge.id, :challenger_id => challenge.challenger_id, :challengee_id => challenge.challengee_id, :accepted => challenge.accepted, :created_at => challenge.created_at, :updated_at => challenge.updated_at, :this_user_count => this_shots.count, :that_user_count => that_shots.count}
      array.push(challenge_hash)
    end
    challenge_details = array
    json challenge_details
  end

  def challenge_player
    player = User.find_by_id(challenge_params[:player_id])

    # Check for an existing challenge
    @logged_user.challenges.each do |ch|
      if (ch.challengee_id==player.id)
        error 'You already have sent a challenge to this player.'
        return
      end
    end

    if (@logged_user.challenge player)
      json @logged_user.challenges
    else
      error 'Could not challenge player'
    end
  end

  def challenge_params
    params.permit(:player_id)
  end

  def accept_challenge_params
    params.permit(:auth_token, :challenger_id, :type)
  end

  def quit_challenge_params
    params.permit(:auth_token, :challenge_id)
  end

end
