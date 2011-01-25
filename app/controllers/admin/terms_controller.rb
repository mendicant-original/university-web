class Admin::TermsController < Admin::Base
  before_filter :find_term, :only => [:edit, :update, :destroy]

  def index
    @terms = Term.order('created_at')
  end

  def new
    @term = Term.new
  end

  def create
    @term = Term.new(params[:term])

    if @term.save
      flash[:notice] = "Term sucessfully created."
      redirect_to admin_terms_path
    else
      render :action => :new
    end
  end

  def edit
    @unregistered = @term.exams.map {|e| e.users }.flatten.select {|u| u.open_registrations.any? }
  end

  def update
    if @term.update_attributes(params[:term])
      flash[:notice] = "Term sucessfully updated."
      redirect_to admin_terms_path
    else
      render :action => :edit
    end
  end

  def destroy
    @term.destroy

    flash[:notice] = "Term sucessfully destroyed."
    redirect_to admin_terms_path
  end

  private

  def find_term
    @term = Term.find(params[:id])
  end
end
