module NavigationHelper
  def sign_link
    if user_signed_in?
      link_to t('.sign_out'), destroy_user_session_path, method: :delete
    else
      link_to t('.sign_in'), new_user_session_path
    end
  end
end
