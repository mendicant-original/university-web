class Courses::AssignmentsController < Courses::Base
  before_filter :find_assignment

  def show
    @submissions = @assignment.submissions.includes(:status).
                    order("submission_statuses.sort_order").group_by(&:status)
    @activities = @assignment.recent_activities.paginate(:page => params[:page],
                                                         :per_page => 10)

    respond_to do |format|
      format.html
      format.text { render :text => @assignment.notes }
      format.gz do
        send_data Assignment::Exporter.new(@assignment).to_gzip,
                  :filename => "#{@assignment.name.parameterize}.gz"
      end
    end
  end

  def notes
    @assignment.update_attribute(:notes, params[:value])

    respond_to do |format|
      format.text
    end
  end

  private

  def find_assignment
    @assignment  = @course.assignments.find(params[:id])
  end
end
