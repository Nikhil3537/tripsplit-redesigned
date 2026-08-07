class InvitationsController < ApplicationController
  before_action :set_invitation

  def show
    if logged_in?
      Membership.find_or_create_by!(
        trip: @invitation.trip,
        user: current_user
      ) do |membership|
        membership.role = "member"
      end

      @invitation.update!(
        status: "accepted",
        accepted_at: Time.current
      )

      redirect_to @invitation.trip,
                  notice: "You have joined the trip successfully."
    else
      session[:invitation_token] = @invitation.token

      redirect_to new_session_path,
                  alert: "Please log in to join the trip."
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find_by!(token: params[:token])
  end
end