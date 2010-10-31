class Admin::DocumentsController < Admin::Base
  before_filter :find_document, :only => [:edit, :show, :update, :destroy]
  
  def index
    @documents = Document.order("title")
    
    if params[:search]
      search = "%#{params[:search]}%"
      
      @documents = @documents.where(["title ILIKE ? OR body ILIKE ?", 
        search, search])
    end
    
    @documents = @documents.paginate(:page => params[:page])
  end
  
  def new
    @document = Document.new
  end
  
  def create
    @document = Document.new(params[:document])
    
    if @document.save
      flash[:notice] = "Document sucessfully created."
      redirect_to admin_documents_path
    else
      render :action => :new
    end
  end
  
  def update
    if @document.update_attributes(params[:document])
      flash[:notice] = "Document sucessfully updated."
      redirect_to admin_documents_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @document.destroy
    
    flash[:notice] = "Document sucessfully destroyed."
    redirect_to admin_documents_path
  end
  
  private
  
  def find_document
    @document = Document.find(params[:id])
  end
end
