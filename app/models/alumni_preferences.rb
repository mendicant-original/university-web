class AlumniPreferences < ActiveRecord::Base
  before_create :set_defaults

  private

  def set_defaults
    self.show_on_public_site = true if show_on_public_site.nil?
    self.show_twitter        = true if show_twitter.nil?
    self.show_github         = true if show_github.nil?
    self.show_real_name      = true if show_real_name.nil?
  end
end
