require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: 'user1', email: 'user1@user.com', password: 'password', admin: true)
    sign_in_as(@admin_user)
  end
  
  test "get the new category form then create category" do
    get "/categories/new" # or we can also use new_category_path instead of the URL
    assert_response :success # assert_response checks the HTTP status code
    
    assert_difference 'Category.count', 1 do
      post categories_path, params: {category: {name: "Announcements"}}
      assert_response :redirect
    end
    
    follow_redirect! # redirects the user to the page that the "create" action sends the user to upon successful save, in this case, the category listing
    assert_response :success
    
    assert_match "Announcements", response.body # Looks for the word "Announcements" in the category listing page using the page's HTML body
  end
  
  test "get new category form then reject invalid category" do
    get new_category_path
    assert_response :success
    
    assert_no_difference 'Category.count' do
      post categories_path, params: {category: {name: ""}}
      assert_response :redirect
    end
    
    follow_redirect!
    assert_match "Name can&#39;t be blank", response.body
  end
end
