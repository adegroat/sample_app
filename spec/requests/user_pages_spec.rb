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

		describe "while already signed in" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in(user) }

			describe "submitting a GET request" do
				before { get signup_path }
				specify { expect(response).to redirect_to(user) }
			end

			describe "submitting a POST request" do
				before { post '/users' }
				specify { expect(response).to redirect_to(user) }
			end

		end

	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Micro post 1") }
		let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Micro post 2") }

		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_title(correct_title(user.name)) }

		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) }
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			cb_sign_in(user)
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_content("Update your profile") }
			it { should have_title(correct_title("Update profile")) }
			it { should have_link("Change", href: "http://gravatar.com/emails") }
		end

		describe "with invalid info" do
			before { click_button("Update") }

			it { should have_selector("p.alert.alert-error") }
		end

		describe "with valid info" do
			let(:new_name) { "New Name" }
			let(:new_email) { "new.email@mail.com" }

			before do
				fill_in("Name", with: new_name)
				fill_in("Email", with: new_email)
				fill_in("Password", with: user.password)
				fill_in("Password confirmation", with: user.password)
				click_button("Update")
			end

			it { should have_selector("div.alert.alert-success") }
			it { should have_selector('h1', text: new_name) }
			it { should have_title(correct_title(new_name)) }

		end
	end

	describe "index" do
		before do
			cb_sign_in(FactoryGirl.create(:user))
			15.times { FactoryGirl.create(:user) }
			visit(users_path)
		end

		it { should have_title(correct_title("All Users")) }
		it { should have_content("All Users") }

		it { should have_selector("div.pagination") }

		it "should list each user" do
			User.paginate(page: 1, per_page: 15).each do |user|
				expect(page).to have_link(user.name, href: user_path(user))
			end
		end

		describe "delete links" do
			it { should_not have_link("Delete") }

			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					cb_sign_in(admin)
					visit(users_path)
				end

				it { should have_link("Delete", href: user_path(User.first)) }

				it "should be able to delete other users" do
					expect{ click_link("Delete", match: :first) }.to change(User, :count).by(-1)
				end

				it { should_not have_link("Delete", href: user_path(admin)) }
			end

		end

	end

end
