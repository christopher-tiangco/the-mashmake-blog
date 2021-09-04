class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:new, :signup_success, :create, :show, :index]
    before_action :require_same_user_or_admin, except: [:new, :signup_success, :create, :show, :index]
    
    def new
        @user = User.new
    end
    
    def signup_success
    end
    
    def create
        @user = User.new(user_params)
        
        if @user.save
            flash[:notice] = {successMessage:  "Welcome #{@user.username}!"}
            session[:user_id] = @user.id
            redirect_to articles_path
        else
            error_full_messages = @user.errors.full_messages
            flash[:notice] = {"errorMessages" => error_full_messages}
            
            redirect_to signup_path
        end
    end
    
    def edit
    end
    
    def update
        if @user.update(user_params)
            flash[:notice] = {successMessage:  "Successfully updated profile."}
            redirect_to user_path(@user)
        else
            errorMessages = @user.errors.full_messages
            flash[:notice] = {errorMessages:  errorMessages}
            redirect_to edit_user_path
        end
    end
    
    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end
    
    def index
        @users = User.paginate(page: params[:page], per_page: 3)
    end
    
    def destroy
        if @user.destroy
            flash[:notice] = {successMessage: "Account successfully deleted."}
            if !current_user.admin?
                session[:user_id] = nil
                redirect_to root_path
            else
                redirect_to users_path
            end
        else
            errorMessages = @user.errors.full_messages
            flash[:notice] = {errorMessages:  errorMessages}
            redirect_to edit_user_path
        end
    end
    
    private
    
    def set_user
        begin # begin..rescue..end is similar to try-catch clause in other programming languages
            @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            flash[:notice] = { errorMessages: ["User not found"] }
            redirect_to users_path
        end
    end
    
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    
    def require_same_user_or_admin
        if current_user != @user && !current_user.admin?
            redirect_to root_path
        end
    end
end