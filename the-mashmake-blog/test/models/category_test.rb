require "test_helper"

class CategoryTest < ActiveSupport::TestCase
    def setup
        @category = Category.new
    end
    
    test "category should be valid" do 
        @category.name = "Sports"
        assert @category.valid?
    end
    
    test "should have a name" do
        @category.name = " "
        assert_not @category.valid?
    end
    
    test "name should be unique" do
        @category.name = "Sports"
        @category.save
        @category2 = Category.new(name: "Sports")
        assert_not @category2.valid?
    end
    
    test "name should not be too long" do
        @category.name = "x" * 26
        assert_not @category.valid?
    end
    
    test "name should not be too short" do
        @category.name = "x"
        assert_not @category.valid?
    end
end