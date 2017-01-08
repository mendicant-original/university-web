require 'test_helper'

class CoursesHelperTest < ActionView::TestCase
  include CoursesHelper

  context '#course_dates' do
    context 'for a course with a start and end date' do
      setup do
        @course = Factory(:course,
                          :start_date => Date.parse('2010-09-17'),
                          :end_date => Date.parse('2010-11-01'))
      end

      test 'show the duration of the course' do
        assert_equal '17 September 2010 thru 01 November 2010',
                     course_dates(@course)
      end
    end

    context 'for a course lacking an end date' do
      setup do
        @course = Factory(:course, :start_date => nil)
      end

      test 'be an empty string' do
        assert_equal '', course_dates(@course)
      end
    end
  end

  context '#highlighted_snippet' do
    context 'for a string that does not contain the keyword' do
      test 'return a prefix of the string' do
        string  = "this is a sample text that does not contain the keyword"
        keyword = "test"
        snippet = highlighted_snippet(string, keyword)
        assert string.start_with? snippet
      end
    end

    context 'for a string that contains the keyword' do
      test 'returns a substring that contains the keyword' do
        string  = "this is a test text that does contain the keyword"
        keyword = 'test'
        snippet = highlighted_snippet(string, keyword, :surround => 5)

        assert snippet.include? keyword
      end
    end
  end
end
