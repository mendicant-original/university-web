require 'test_helper'
require 'mocha'

module Courses
  class SearchTest < ActionDispatch::IntegrationTest
    context "As a user, I want to have full text-search capabilities" do            
      context "# In a course" do                                         
        setup do
          @course = Factory(:course)
          @user = sign_user_in
          Factory(:course_membership, :user => @user, :course => @course)
          2.times do |i|
            user = Factory(:user, :nickname => "Student #{i+1}")
            Factory(:course_membership, :user => user, :course => @course)
          end                       
        end
            
        test "I don't get result if there is no match" do
          pending()
          #visit course_path(@course, :anchor => "search")
          #fill_in 'search', with: 'blablabla'
          #click_button('Search')
          #assert_content 'No matches found'
        end
        
        test "I get results from the course's description" do
          pending()
          #visit course_path(@course, :anchor => "search")
          #fill_in 'search', with: 'lorem'
          #click_button('Search')
          #assert_content "Course's Description"
        end                                            
        
        test "I get results from the Notes" do
          pending()
        end                   
        
        context "# In its IRC" do
          test "I get results from the log" do
            pending()
          end
        end
                
        context "# In an Assigment" do
          test "I get results from the Description" do
            pending()
          end        
          
          test "I get results from the notes" do
            pending()
          end                   
          
          context "# In a Submission" do
            test "I get results form the description" do
              pending()
            end                                   
            
            test "I get results from the Comments" do
              pending()
            end
          end
        end                                  
      end      
    end
  end
end