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
			before { cb_sign_in(user) }

			it { should have_title(correct_title(user.name)) }
			it { should have_link('Users', href: users_path) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			it { should_not have_link('Sign up', href: signup_path) }
		end
	end

	describe "non signed in users in the Users controller" do

		let(:user) { FactoryGirl.create(:user) }

		describe "visiting the edit page" do
			before { visit(edit_user_path(user)) }
			it { should have_title(correct_title('Sign in')) }
		end

		describe "submitting to the update action" do
			before { patch user_path(user) }
			specify { expect(response).to redirect_to(signin_path) }
		end

		describe "when attempting to visit a protected page" do
			before do
				visit(edit_user_path(user))
				cb_sign_in(user)
			end

			describe "after successfully signing in" do
				it "should render the desired protected page" do
					expect(page).to have_title("Update profile")
				end
			end
		end

		describe "when visiting the user index" do
			before { visit(users_path) }
			it { should have_title("Sign in") }
		end

	end

	describe "editing a profile that's not yours" do
		let(:user) { FactoryGirl.create(:user) }
		let(:another_user) { FactoryGirl.create(:user, email: "another.user@mail.com") }

		before { sign_in(user) }

		describe "GET request to Users#edit action" do
			before { get edit_user_path(another_user) }
			specify { expect(response).to redirect_to(root_path) }
		end

		describe "PATCH request to Users#update action" do
			before { patch user_path(another_user) }
			specify { expect(response).to redirect_to(root_path) }
		end
	end

	describe "as a non admin user" do
		let(:user) { FactoryGirl.create(:user) }
		before { sign_in(user) }

		describe "submitting a DELETE request to Users#destroy" do
			before { delete user_path(user) }
			specify { expect(response).to redirect_to(root_path) }
		end
	end


end