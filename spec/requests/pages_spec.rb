require 'spec_helper'

describe "Pages" do


	describe "Home page" do
		it "should have content 'Sample App'" do
			visit root_path
			expect(page).to have_content('Sample App')
		end
	end

	describe "Help page" do
		it "should have content 'Help'" do
			visit help_path
			expect(page).to have_content('Help')
		end
	end

	describe "About page" do
		it "should have content 'About'" do
			visit about_path
			expect(page).to have_content('About')
		end
	end

end
