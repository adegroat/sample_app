require 'spec_helper'

describe "User pages" do

	subject { page }
  	
	describe "sign up page" do
		before { visit signup_path }
		it { should have_content('Sign up') }
		it { should have_title(correct_title('Sign up')) }
	end

	describe "signing up" do
		before { visit signup_path }
		let(:signup) {"Sign up"}

		describe "with invalid info" do
			it "should not create a user" do
				expect { click_button(signup) }.not_to change(User, :count)
			end
		end

		describe "with valid info" do
			it "should create a user" do
				fill_in("Name", with: "Bob DeProte")
				fill_in("Email", with: "bob.deprote@email.com")
				fill_in("Password", with: "monkey123")
				fill_in("Confirm password", with: "monkey123")

				expect { click_button(signup) }.to change(User, :count).by(1)

			end
		end

	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_title(correct_title(user.name)) }
	end

end
