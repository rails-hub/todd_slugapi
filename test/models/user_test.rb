require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save a challenge without a challengee" do
    c = Challenge.new
    c.challenger_id = 1
    assert !c.save
  end

end
