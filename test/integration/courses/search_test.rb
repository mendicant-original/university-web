require 'test_helper'
require 'mocha'

module Courses
  class SearchTest < ActionDispatch::IntegrationTest
    context "As a user, I want to have full text-search capabilities" do
      context "# In a course" do
        setup do
          tests_javascript

          channel = Factory(:chat_channel, :name => "mendicant")
          message = Factory(:chat_message, :channel => channel,
                             :body => "chat message")
          @course = Factory(:course,
                            :description => 'lorem',
                            :notes => 'ipsum',
                            :channel => channel)

          @user = sign_user_in
          Factory(:course_membership, :user => @user, :course => @course)
        end

        test "I don't get result if there is no match" do
          visit course_path(@course, :anchor => "search")
          fill_in 'search', with: 'blablabla'
          click_button('Search')
          assert_content 'Found 0 results'
        end

        test "I get results from the course's description" do
          visit course_path(@course, :anchor => "search")
          fill_in 'search', with: 'lorem'
          click_button('Search')
          assert_content "Course's description"
        end

        test "I get results from the Notes" do
          visit course_path(@course, :anchor => "search")
          fill_in 'search', with: 'ipsum'
          click_button('Search')
          assert_content "Shared Notes"
        end

        context "# In its IRC" do
          test "I get results from the log" do
            visit course_path(@course, :anchor => "search")
            fill_in 'search', with: 'chat message'
            click_button('Search')
            assert_content "Irc Channel"
          end
        end

        context "# In an Assigment" do
          setup do
            @assignment = Factory(:assignment, :course => @course,
                                  :description => "dolor", :notes => "sit amet")
          end

          test "I get results from the Description" do
            visit course_path(@course, :anchor => "search")
            fill_in 'search', with: 'dolor'
            click_button('Search')
            assert_content "Assignments"
          end

          test "I get results from the notes" do
            visit course_path(@course, :anchor => "search")
            fill_in 'search', with: 'sit amet'
            click_button('Search')
            assert_content "Assignments"
          end

          context "# In a Submission" do
            setup do
              @submission = Factory(:submission, :assignment => @assignment,
                                   :description => "test description")
            end

            test "I get results from the description" do
              visit course_path(@course, :anchor => "search")
              fill_in 'search', with: 'test description'
              click_button('Search')
              assert_content "Submissions"
            end

            test "I get results from the Comments" do
              @comment = Factory(:comment, :commentable => @submission,
                                 :comment_text => "comment text")
              visit course_path(@course, :anchor => "search")
              fill_in 'search', with: 'comment text'
              click_button('Search')
              assert_content "Submission Comments"
            end
          end
        end
      end
    end
  end
end
