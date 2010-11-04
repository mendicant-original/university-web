module PublicHelper
  def current_page(name, current)
    'current' if name == 'alumni'
  end
  
  def alumnus_name(alumnus)
    if alumnus.alumni_preferences.show_on_public_site
      if alumnus.alumni_preferences.show_real_name
        !alumnus.real_name.blank? ? alumnus.real_name : alumnus.nickname
      else 
        !alumnus.nickname.blank? ? alumnus.nickname : "Alumnus ##{alumnus.alumni_number}"
      end
    else
      "Alumnus ##{alumnus.alumni_number}"
    end
  end
  
  def show_twitter?(alumnus)
    alumnus.alumni_preferences.show_on_public_site && 
    alumnus.alumni_preferences.show_twitter && 
    !alumnus.twitter_account_name.blank?
  end
  
  def show_github?(alumnus)
    alumnus.alumni_preferences.show_on_public_site && 
    alumnus.alumni_preferences.show_github && 
    !alumnus.github_account_name.blank?
  end
  
  def alumnus_image(alumnus)
    if alumnus.alumni_preferences.show_on_public_site
      alumnus.gravatar_url(64)
    else
      "http://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm&s=64"
    end
  end
end
