require 'spec_helper'

describe "Pages" do

	subject { page }

	describe "Home page" do
		before { visit(root_path) }
		it { should have_content('Welcome') }
		it { should have_title(correct_title('Home')) }

		describe "for signed in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:micropost, user: user, content: "test post 1")
				FactoryGirl.create(:micropost, user: user, content: "test micropost 2")
				cb_sign_in(user)
				visit(root_path)
			end

			it "should have the user's feed" do
				user.feed.each do |f|
					expect(page).to have_selector("li##{f.id}", text: f.content)
				end
			end

		end

	end

	describe "Help page" do
		before { visit(help_path) }
		it { should have_selector('h1', text: 'Help') }
		it { should have_title(correct_title('Help')) }
	end

	describe "About page" do
		before { visit(about_path) }
		it { should have_selector('h1', text: 'About') }
		it { should have_title(correct_title('About')) }
	end

	describe "Contact page" do
		before { visit(contact_path) }
		it { should have_selector('h1', text: 'Contact') }
		it { should have_title(correct_title('Contact')) }
	end

	
end
