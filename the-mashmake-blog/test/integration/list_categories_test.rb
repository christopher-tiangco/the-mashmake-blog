require 'test_helper'

class ListCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @category1 = Category.create(name: "Category1");
    @category2 = Category.create(name: "Category2");
  end
  
  test "should show category listing" do
    get categories_path
    assert_response :success
    
    assert_select "a[href=?]", category_path(@category1)
    assert_select "a[href=?]", category_path(@category2)
  end
end
