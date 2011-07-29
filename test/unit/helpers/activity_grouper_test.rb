require 'test_helper'

class Assignment::ActivityGrouperTest < ActionView::TestCase

  context "no activities" do

    setup do
      @grouped = Assignment::ActivityGrouper.new([]).group_by_description
    end

    test "return an empty array" do
      assert_equal 0, @grouped.length
    end

  end

  context "one activity" do

    setup do
      @activity = Factory(:activity)
      @grouped = Assignment::ActivityGrouper.new([@activity]).group_by_description
    end

    test "return one result" do
      assert_equal 1, @grouped.length
    end

    test "return the activity" do
      assert_equal @activity, @grouped[0][0]
    end

    test "have no grouped activities" do
      assert_equal 0, @grouped[0][1].length
    end

  end

  context "two activities - same description" do

    setup do
      @activity_one = Factory(:activity)
      @activity_one.description = "updated description"

      @activity_two = Factory(:activity)
      @activity_two.description = "updated description"

      @activities = [@activity_one, @activity_two]
      @grouped = Assignment::ActivityGrouper.new(@activities).group_by_description
    end

    test "return one result" do
      assert_equal 1, @grouped.length
    end

    test "return the first activity" do
      assert_equal @activity_one, @grouped[0][0]
    end

    test "have one activity in the group" do
      assert_equal 1, @grouped[0][1].length
    end

    test "include the other activity in the group" do
      assert_equal @activity_two, @grouped[0][1][0]
    end

  end

  context "two activities - different descriptions" do

    setup do
      @activity_one = Factory(:activity)
      @activity_one.description = "updated description"

      @activity_two = Factory(:activity)
      @activity_two.description = "something else"

      @activities = [@activity_one, @activity_two]
      @grouped = Assignment::ActivityGrouper.new(@activities).group_by_description
    end

    test "return two results" do
      assert_equal 2, @grouped.length
    end

  end

  context "two github commit activities" do

    setup do
      @activity_one = Factory(:activity)
      @activity_one.description = "Github commit"

      @activity_two = Factory(:activity)
      @activity_two.description = "Github commit"

      @activities = [@activity_one, @activity_two]
      @grouped = Assignment::ActivityGrouper.new(@activities).group_by_description
    end

    test "return one result" do
      assert_equal 1, @grouped.length
    end

    test "include the other activity in the group" do
      assert_equal @activity_two, @grouped[0][1][0]
    end

  end

end