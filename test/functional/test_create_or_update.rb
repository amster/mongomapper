require 'test_helper'

class CreateOrUpdateTest < Test::Unit::TestCase
  context "create or update a document" do
    setup do
      @document = Doc do
        key :name, String, :required => true, :unique => true
        key :email, String
      end
    end
    
    should "be able to create a document" do
      @document.create!(:name => 'Larry', :email => 'larry@someplace.com')
      assert_equal 1, @document.all.count
    end

    should "not be able to create a document with the same name" do
      begin
        @document.create!(:name => 'Curly', :email => 'curly@someplace.com')
        assert_equal 1, @document.all.count
        @document.create!(:name => 'Curly', :email => 'another_curly@anotherplace.com')
        raise
      rescue
        # OK
      end
    end
    
    should "be able to create or update a document with the same name" do
      @document.create_or_update({:name => 'Moe'}, {:name => 'Moe', :email => 'moe@someplace.com'})
      assert_equal 1, @document.all.count
      @document.create_or_update({:name => 'Moe'}, {:name => 'Moe', :email => 'slow_moe@someplace.com'})
      assert_equal 1, @document.all.count
      assert_equal 'slow_moe@someplace.com', @document.first(:name => 'Moe').email
    end
  end
end
