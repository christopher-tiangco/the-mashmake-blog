Rails.application.routes.draw do
  scope '/learn/udemy-alpha-blog' do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root 'pages#home'
    get 'about', to: 'pages#about'
    resources :articles # expects predefined methods in the ArticlesController to exist. Methods are: new, create, edit, update, delete and index
    get 'signup', to: 'users#new'
    resources :users, except: [:new]
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :categories
  end
end
