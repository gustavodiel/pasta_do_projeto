json.user do |json|
  json.partial! 'users/user', user: current_user
  json.message 'User updated successfully'
end
