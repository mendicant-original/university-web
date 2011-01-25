class Admin::GroupMailsController < Admin::Base

  def new
    @group_mail = GroupMail.new
  end

  def create
    @group_mail = GroupMail.new(params[:group_mail])
    if @group_mail.valid?
      GroupMailer.mass_email(@group_mail).deliver
      flash[:notice] = "Your message has been sent successfully."
      redirect_to admin_users_path
    else
      @group = GroupMail.identify_group(@group_mail.group_type)
      render :action => 'new'
    end
  end


  def update_group_select
    respond_to do |format|
      format.json {
        @group = GroupMail.identify_group(params[:group_type])
        render :json => @group.to_json
      }
    end
  end

  def user_emails
    respond_to do |format|
      format.text {
        @to_emails = GroupMail.find_group_emails(params[:group_type],
                     params[:group_id])
        render :text => @to_emails
      }
    end
  end

end
