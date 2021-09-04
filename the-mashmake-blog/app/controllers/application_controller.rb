class ApplicationController < ActionController::Base
    
    # This makes the following methods available to the views as if this methods were defined in ApplicationHelper
    helper_method :current_user, :logged_in?, :require_user
    
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def logged_in?
        !!current_user
    end
    
    def require_user
        if !logged_in?
            redirect_to root_path
        end
    end
end
