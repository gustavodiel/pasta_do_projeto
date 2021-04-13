json.user do |json|
  json.partial! 'users/user', user: current_user
  json.images do
    json.array! current_user.images do |image|
      json.partial! 'api/images/image', { image: image }
    end
  end
end
