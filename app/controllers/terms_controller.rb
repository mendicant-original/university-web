class TermsController < ApplicationController
  
  def registration
    @term = Term.find(params[:id])
    
    unless current_user.open_registrations.include? @term
      flash[:error] = "You are not authorized to register for this term"
      redirect_to root_path
      return
    end
  end

end
