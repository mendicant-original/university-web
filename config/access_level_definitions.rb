AccessLevel::User.instance_eval do
  define "guest",
    :permissions => []
  
  define "student",  
    :permissions => [:view_directory, :view_courses]

  define "admin", 
    :permissions => [:manage_users, :manage_documents]
end

AccessLevel::Course.instance_eval do
  define "student",
    :permissions => [:comment, :create_submissions]    
  
  define "mentor", 
    :permissions => [:comment]
  
  define "instructor",  
    :permissions => [:comment, :create_assignments]
end