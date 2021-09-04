class CategoriesController < ApplicationController
    before_action :set_category, except: [:index, :new, :create]
    before_action :require_admin, except: [:index, :show]
    
    def index
        @categories = Category.paginate(page: params[:page], per_page: 5)
    end
    
    def show
        @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
    end
    
    def new
        @category = Category.new
    end
    
    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:notice] = { successMessage: "Category was saved." }
            redirect_to categories_path
        else
            errorMessages = []
            
            @category.errors.full_messages.each do |msg|
                errorMessages.append("#{msg}")
            end

            flash[:notice] = { errorMessages: errorMessages }
            
            redirect_to new_category_path
        end
    end
    
    def edit
    end
    
    def update
        if @category.update(category_params)
            flash[:notice] = { successMessage: "Category was updated for Category ID: #{@category.id.to_s}" }
            redirect_to categories_path
        else
            errorMessages = []
            
            @category.errors.full_messages.each do |msg|
                errorMessages.append("#{msg} for Category ID: #{@category.id.to_s}")
            end

            flash[:notice] = { errorMessages: errorMessages }
            
            redirect_to edit_category_path
        end
    end
    
    def destroy
        if @category.destroy
            flash[:notice] = { successMessage: "Successfully deleted the category." }
            redirect_to categories_path
        else
            errorMessages = []
            
            @category.errors.full_messages.each do |msg|
                errorMessages.append("#{msg}")
            end

            flash[:notice] = { errorMessages: errorMessages }
            
            redirect_to new_category_path
        end
    end
    
    private
    
    def category_params
        params.require(:category).permit(:name)
    end
    
    def set_category
        begin
            @category = Category.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            flash[:notice] = { errorMessages: ["Category not found"] }
            redirect_to categories_path
        end
    end
    
    def require_admin
        if !(logged_in? && current_user.admin?)
            flash[:notice] = { errorMessages: ["Only admins can create/delete category"] }
            redirect_to categories_path
        end
    end
end