class PublicController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed
  before_filter      :set_current_section
  before_filter      :set_alumni_links, :only => [:alumni, :recent_alumni]

  layout 'static'

  # Find the list of alumni, which can be all of them,
  # filtered by year or by year and term slug.
  def alumni
    if params[:term]
      redirect_to("/alumni") && return if !params[:year]

      @term = Term.per_year(params[:year]).where(:slug => params[:term]).first
      @alumni = @term.alumni
    else
      @alumni = User.alumni
      @alumni = @alumni.per_year(params[:year]) if params[:year]
    end
  end

  # List the alumni of the most recent Term that has alumni
  def recent_alumni
    @term = Term.order("start_date DESC").select {|t| !t.alumni.blank?}.first
    redirect_to("/alumni") && return if !@term
    @alumni = @term.alumni

    render 'alumni'
  end

  def changelog
    @announcements = Announcement.where(:public => true).order("created_at DESC")

    respond_to do |format|
      format.html do
        @announcements = @announcements.paginate(:page => params[:page], :per_page => 10)
      end
      format.rss { render :layout => false }
    end
  end

  def announcement
    @announcement = Announcement.find_by_slug(params[:slug])

    if @announcement.nil? || !@announcement.public?
      render(:text => "This announcement doesn't exist")
      return
    end
  end

  private

  def set_current_section
    @current = params[:action]
  end

  # Prepares a hash with all the years and term names/slugs for the terms
  # that have alumni, to be used for the links bar on '/alumni'
  # In this format:
  #
  # {
  #   :2010 => [['First Session', 'first-session']],
  #   :2011 => [['T1', 't1'], ['T2', 't2']]
  # }
  def set_alumni_links
    @alumni_links = {}
    terms = Term.order('start_date').all.select {|t| t.alumni.count > 0}
    terms.map {|t| [t.start_date.year, [t.name, t.slug]]}.each do |term|
      @alumni_links[term[0]] = [] if !@alumni_links[term[0]]
      @alumni_links[term[0]] << term[1]
    end
  end
end



