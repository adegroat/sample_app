require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "Sign in page" do
		before { visit(signin_path()) }
		it { should have_content('Sign in') }
		it { should have_title(correct_title('Sign in')) }
	end

	describe "signing in" do
		before { visit(signin_path) }

		describe "with invalid info" do
			before { click_button('Sign in') }
			it { should have_title(correct_title('Sign in')) }
			it { should have_selector('div.alert.alert-error') }
		end

		describe "with valid info" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in("Email", with: user.email.upcase)
				fill_in("Password", with: user.password)
				click_button('Sign in')
			end

			it { should have_title(correct_title(user.name)) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			it { should_not have_link('Sign up', href: signup_path) }
		end

	end

end