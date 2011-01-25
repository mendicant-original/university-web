class DashboardController < ApplicationController
  before_filter { @selected = :dashboard }
  
  def show
  end
end
