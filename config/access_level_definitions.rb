AccessLevel::User.instance_eval do
  define "guest",
    :permissions => []
  
  define "student",  
    :permissions => [:do_stuff]

  define "admin", 
    :permissions => [:manage_users]
end

AccessLevel::Course.instance_eval do
  define "student",
    :permissions => [:comment, :create_submissions]    
  
  define "mentor", 
    :permissions => [:comment]
  
  define "instructor",  
    :permissions => [:comment, :create_assignments]
end