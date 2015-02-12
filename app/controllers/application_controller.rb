class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def user_for_paper_trail
    admin_user_signed_in? ? current_admin_user.id : 'guest'
  end

  def rollback(object)
    object.class.name.constantize.paper_trail_on!
    if admin_user_signed_in?
    object.save_after_state
    else
    object.rollback
    end
    object.class.name.constantize.paper_trail_off!
  end

  # Approves for admin, pending otherwise (for create method)
  def handle_creation(object)
    object.class.name.constantize.paper_trail_on!
    if admin_user_signed_in?
    object.save_after_state
    else
    object.destroy
    end
    object.class.name.constantize.paper_trail_off!
  end

  private

  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end

end
