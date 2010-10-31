class DocumentsController < ApplicationController
  
  def index
    @documents = Document.where(:public_internal => true).
      order("title").paginate(:page => params[:page])
  end
  
  def show
    @document = Document.find(params[:id])
    
    unless @document.public_internal
      if (current_user.courses & @document.courses).empty?
        flash[:error] = "You do not have access to view this document."
        redirect_to root_path
        return
      end
    end
  end
end
