class PublicController < ApplicationController
  layout 'static'
  
  def alumni
    @current = 'alumni'
    @alumni  = User.order("alumni_number").select {|u| u.alumnus? }
  end
end
