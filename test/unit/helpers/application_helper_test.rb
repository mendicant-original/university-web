require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  context "user map tag helper" do
    setup do
      User.expects(:locations).returns([ [1.0, 2.0], [3.0, 4.0], [5.0, 6.0] ])
    end

    test "generates map tag with default options" do
      expected = '<img ' +
        'alt="User Map" ' +
        'src="http://maps.google.com/maps/api/staticmap?' +
        'sensor=false' +
        '&amp;zoom=0' +
        '&amp;size=512x512' +
        '&amp;markers=1.0,2.0%7C3.0,4.0%7C5.0,6.0' +
        '" />'

      assert_equal expected, user_map_tag
    end

    test "generates map tag with custom width" do
      expected = '<img ' +
        'alt="User Map" ' +
        'src="http://maps.google.com/maps/api/staticmap?' +
        'sensor=false' +
        '&amp;zoom=0' +
        '&amp;size=250x512' +
        '&amp;markers=1.0,2.0%7C3.0,4.0%7C5.0,6.0' +
        '" />'

      assert_equal expected, user_map_tag(:width => 250)
    end

    test "generates map tag with custom height" do
      expected = '<img ' +
        'alt="User Map" ' +
        'src="http://maps.google.com/maps/api/staticmap?' +
        'sensor=false' +
        '&amp;zoom=0' +
        '&amp;size=512x100' +
        '&amp;markers=1.0,2.0%7C3.0,4.0%7C5.0,6.0' +
        '" />'

      assert_equal expected, user_map_tag(:height => 100)
    end

    test "generates map tag with custom zoom level" do
      expected = '<img ' +
        'alt="User Map" ' +
        'src="http://maps.google.com/maps/api/staticmap?' +
        'sensor=false' +
        '&amp;zoom=10' +
        '&amp;size=512x512' +
        '&amp;markers=1.0,2.0%7C3.0,4.0%7C5.0,6.0' +
        '" />'

      assert_equal expected, user_map_tag(:zoom_level => 10)
    end
  end
end
