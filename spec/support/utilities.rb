def correct_title(title)
	title.empty? ? "Sample App" : "#{title} - Sample App"
end

def sign_in(user)
	remember_token = User.new_remember_token
	cookies[:remember_token] = remember_token
	user.update_attribute(:remember_token, User.sha1(remember_token))
end

def cb_sign_in(user)
	visit signin_path
	fill_in("Email", with: user.email.upcase)
	fill_in("Password", with: user.password)
	click_button("Sign in")
end
