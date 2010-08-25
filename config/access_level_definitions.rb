AccessLevel::User.instance_eval do
  define "guest",
    :permissions => []
  
  define "student",  
    :permissions => [:do_stuff]

  define "admin", 
    :permissions => [:manage_users]
end