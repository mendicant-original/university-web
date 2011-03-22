AccessLevel::User.instance_eval do
  define "guest",
    :permissions => []
    
  define "applicant",
    :permissions => []
  
  define "student",
    :permissions => [:view_directory, :view_courses]

  define "alumnus",
    :parent      => "student",
    :permissions => [:discuss_admissions]

  define "admin",
    :parent      => "alumnus",
    :permissions => [:manage_users, :manage_documents, :update_admissions_status]
end

AccessLevel::Course.instance_eval do
  define "student",
    :permissions => [:comment, :create_submissions]    
  
  define "mentor", 
    :permissions => [:comment]
  
  define "instructor",  
    :permissions => [:comment, :create_assignments]
end