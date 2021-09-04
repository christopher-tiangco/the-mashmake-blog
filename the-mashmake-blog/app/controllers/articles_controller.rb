class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy] # set_article method will be called before any of the methods specified in `only`
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user_or_admin, except: [:show, :index, :new, :create]
    
    def index
        #byebug # sometimes `byebug` won't stop here. In that case, just restart the puma server
        #@articles = Article.all
        @articles = Article.paginate(page: params[:page], per_page: 5)
    end
    
    def show
    end
    
    def new # Shows the "Create New" form
        @article = Article.new # I have to declare this so that the `form` object in the `_form.html.erb` works
    end
    
    def create # Handles submission from the "Create New" form
        # Typical way of saving the model
        # @article = Article.new
        # @article.title = params[:article][:title]
        # @article.description = params[:article][:description]
        # @article.save
        
        # Shorter way of saving the model by intelligently dealing with params hash
        # IMPORTANT: The `name` attributes used by the form fields in the View layer MUST MATCH the Article class attributes
        # - require(:key1).permit(:key2, :key3) is another way of saying "only get the `:key1` from the `params` hash and only accept/whitelist `:key2` and `:key3` sub-hash from it (any other sub-hashes will be ignored)"
        @article = Article.new(article_params)
        
        @article.user_id = current_user.id # `current_user` method is defined in the ApplicationController
        
        if @article.save
            
            #redirect_to @article # sends to the newly created article page
            
            # Flash is a Rails-provided helper that allows temporarily passing a String, Array or Hash between actions. Once the next action is completely executed, whatever's assigned to this helper is cleared.
            # To eliminate having to write the output of this on every target action (e.g `index` action), this should be implemented in the main layout of the app (app/views/layouts/application.html.erb)
            #flash[:notice] = "Article was saved." 
            flash[:notice] = { successMessage: "Article was saved." } # IMPORTANT: Somehow when this hash is stored into flash[:notice], symbolic keys become string so flash[:notice][:successMessage] is INVALID
            
            redirect_to articles_path # sends to listing (index) - `articles` is the prefix when you run `rails routes` which when appended with `_path`, will yield `/articles` resource path
        else
            # To explain how `@article.errors` exist:
            # - @article is an instance of `Article` model which is a subclass of `ApplicationRecord` which is a subclass of `ActiveRecord::Base`
            # - `ActiveRecord::Base` includes `ActiveRecord::Validations` module
            # - `ActiveRecord::Validations` includes `ActiveRecord::Validations`
            # - `ActiveRecord::Validations` has a method `errors`
            #@error_messages = @article.errors.full_messages 
            #render 'new' # Renders the `new.html.erb` BUT DOES NOT execute the `new` action method above
            
            errorMessages = []
            
            @article.errors.full_messages.each do |msg|
                errorMessages.append("#{msg}")
            end

            flash[:notice] = { errorMessages: errorMessages }
            
            redirect_to new_article_path
        end
        
        #render plain: @article.inspect
    end
    
    def edit # Show the "Edit" form
    end
    
    def update # Handles submission from the "Edit" form
        if @article.update(article_params)
            flash[:notice] = { successMessage: "Article was updated for Article ID: #{@article.id.to_s}" }
            redirect_to articles_path
        else
            errorMessages = []
            
            @article.errors.full_messages.each do |msg|
                errorMessages.append("#{msg} for Article ID: #{@article.id.to_s}")
            end

            flash[:notice] = { errorMessages: errorMessages }
            
            #render 'edit' # this statement doesn't execute the `edit` action above so the flash will end up with the next action method that gets called which is NOT what we wanted
            redirect_to edit_article_path
        end
    end
    
    def destroy
        if @article.destroy
            flash[:notice] = { successMessage: "Article was successfully DELETED for Article ID: #{@article.id.to_s}" }
            redirect_to articles_path
        else
            errorMessages = []
            @article.errors.full_messages.each do |msg|
                errorMessages.append("#{msg} for Article ID: #{@article.id.to_s}")
            end

            flash[:notice] = { errorMessages: errorMessages }
            
            #render 'edit' # this statement doesn't execute the `edit` action above so the flash will end up with the next action method that gets called which is NOT what we wanted
            redirect_to articles_path
        end
        
    end
    
    private # any methods defined after this line are NOT exposed by this class
    
    def set_article
        
        begin # begin..rescue..end is similar to try-catch clause in other programming languages
            @article = Article.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            flash[:notice] = { errorMessages: ["Article not found"] }
            redirect_to articles_path
        end
        
    end

    def article_params
        params.require(:article).permit(:title, :description, category_ids: [])
    end
    
    def require_same_user_or_admin
        if current_user != @article.user && !current_user.admin?
            redirect_to root_path
        end
    end
end
