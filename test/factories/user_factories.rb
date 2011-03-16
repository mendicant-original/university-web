Factory.sequence(:email) { |n| "person#{n}@example.com" }

Factory.define :user do |u|
  u.email                 { |_| Factory.next(:email) }
  u.real_name             'Susannah Waters'
  u.nickname              'suuz'
  u.password              'my password'
  u.password_confirmation 'my password'
  u.requires_password_change false
  u.github_account_name   'rmu_student'
end
