require 'test_helper'

module Courses
  class DirectoryTest < ActionDispatch::IntegrationTest

    story "As a student I want to view the paricipants of my course" do

      setup do
        @course = Factory(:course)
        @user = sign_user_in
        Factory(:course_membership, :user => @user, :course => @course)
        2.times do |i|
          user = Factory(:user, :nickname => "Student #{i+1}")
          Factory(:course_membership, :user => user, :course => @course)
        end
      end

      scenario "view all participants" do

        visit course_path(@course, :anchor => "participants")

        within("div#directory") do
          assert_content "Students"
          assert_css("div.user", :count => 3)
          assert_content @user.nickname
          assert_content "Student 1"
          assert_content "Student 2"
        end
      end

      story "and participants should be grouped by their role" do

        setup do
          @instructor = Factory(:user, :nickname => "Ida Instructress")
          Factory(:course_membership, :user => @instructor, :course => @course, :access_level => "instructor")

          @mentor = Factory(:user, :nickname => "Manny Mentor")
          Factory(:course_membership, :user => @mentor, :course => @course, :access_level => "mentor")
        end

        scenario "role headings are visible" do

          visit course_path(@course, :anchor => "participants")

          within("div#directory") do
            assert_css("h3", :text => 'Instructors')
            assert_css("div.instructors a.user", :count => 1)
            assert_css("h3", :text => 'Mentors')
            assert_css("div.mentors a.user", :count => 1)
            assert_css("h3", :text => 'Students')
            assert_css("div.students a.user", :count => 3)
          end
        end

        scenario "roles are correctly assigned" do

          visit course_path(@course, :anchor => "participants")

          within("div.instructors") do
            assert_content "Ida Instructress"
          end
          within("div.mentors") do
            assert_content "Manny Mentor"
          end
        end

        story "pagination works over grouped participants" do
          # testing for currently set page size of 7
          setup do
            3.times do |i|
              user = Factory(:user, :nickname => "Additional Student #{i+1}")
              Factory(:course_membership, :user => user, :course => @course)
            end
          end

          scenario "when clicking the next page, one student is visible" do
            visit course_path(@course, :anchor => "participants")
            click_link_within("div.pagination", "2")

            within("div#directory") do
              assert_css("h3", :text => 'Students')
              assert_css("div.students a.user", :count => 1)
            end
          end

        end
      end
    end
  end
end