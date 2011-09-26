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
          @search_key = 'lorem'
          
        end
            
        test "I don't get result if there is no match" do
          visit course_path(@course, :anchor => "search")
          fill_in 'search', with: @search_key
          within('div#results') do
            assert_content 'No results'
          end
        end
        
        test "I get results from the course's description" do
          #visit course_path(@course, :anchor => "search")
          #fill_in 'search', with: @search_key
          #within('div#results') do
          #  assert_content @course.name
          #end
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