class Admin::ExamsController < Admin::Base
  before_filter :find_exam, :only => [:show, :update, :edit, :destroy]
  
  def index
    @exams = Exam.order("start_time")
  end
  
  def new
    @exam = Exam.new
  end
  
  def create
    @exam = Exam.new(params[:exam])
    
    if @exam.save
      redirect_to admin_exams_path
    else
      render :action => :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @exam.update_attributes(params[:exam])
      redirect_to admin_exams_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @exam.destroy
    
    redirect_to admin_exams_path
  end
  
  private
  
  def find_exam
    @exam = Exam.find(params[:id])
  end
end
