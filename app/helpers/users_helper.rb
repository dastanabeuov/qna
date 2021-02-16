module UsersHelper
  def user_awards
    current_user.awards.count
  end
end