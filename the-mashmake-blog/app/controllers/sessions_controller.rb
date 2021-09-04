class SessionsController < ApplicationController
    def new
    end
    
    def create
        @user = User.find_by(email: params[:session][:email].downcase)
        
        if @user.nil? || !@user.authenticate(params[:session][:password])
            flash.now[:notice] = {"errorMessages" => ["Invalid email / password"]}
            render 'new'
        else
            session[:user_id] = @user.id
            redirect_to articles_path
        end
    end
    
    def destroy
        session[:user_id] = nil # When logging out, we only have to do this to destroy the session
        flash[:notice] = {"successMessage" => "Successfully logged out"}
        redirect_to root_path
    end
end
