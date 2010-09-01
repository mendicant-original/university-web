module Admin::UsersHelper
  def user_access_level_select(user)
    options = options_for_select(AccessLevel::User.definitions.keys.sort, 
      user.read_attribute(:access_level) || 'student')
    
    select_tag "user_access_level", options, :name => "user[access_level]"
  end
end
