class Courses::DocumentsController < Courses::Base
  before_filter :find_document
  
  def show
    
  end
  
  private
  
  def find_document
    @document = Document.find(params[:id])
  end
end
