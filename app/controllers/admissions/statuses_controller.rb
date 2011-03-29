class Admissions::StatusesController < ApplicationController
  
  def index
    @statuses = Admissions::Status.order("sort_order")
    
    respond_to do |format|
      format.json do
        statuses_hash = {}
        @statuses.each {|s| statuses_hash[s.id] = s.name }
        
        render :json => statuses_hash.to_json
      end
    end
  end
end
