class Admissions::SubmissionsController < ApplicationController
  
  def new
    @user       = User.new
    @submission = Admissions::Submission.new
  end
end
