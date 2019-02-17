# frozen_string_literal: true

module UsersHelper
  # Get user's icon from gravatar. Optionally specify icon size.
  def gravatar_for(user, size: 100)
    if user.email.blank?
      return nil
    end
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.username, class: 'gravatar')
  end

  # Return if current user is admin
  def is_admin?
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
      return false
    end
    @current_user.admin
  end

  # Update last seen of the current user.
  def set_last_seen_at
    current_user.update_column(:last_seen_at, Time.now)
  end
end
