json.(user, :id, :email)
json.token user.generate_token
