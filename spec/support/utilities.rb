def correct_title(title)
	title.empty? ? "Sample App" : "#{title} - Sample App"
end

def cb_sign_in(user)
	visit signin_path
	fill_in("Email", with: user.email)
	fill_in("Password", with: user.password)
	click_button("Sign in")
end