require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "Sign in page" do
		before { visit(signin_path()) }
		it { should have_content('Sign in') }
		it { should have_title(correct_title('Sign in')) }
	end

	describe "signing in" do
		before { visit(signin_path()) }

		describe "with invalid info" do
			before { click_button("Sign in") }
			it { should have_title(correct_title('Sign in')) }
			it { should have_selector('div.alert.alert-error') }
		end

	end

end