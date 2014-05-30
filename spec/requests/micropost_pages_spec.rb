require 'spec_helper'

describe "Micropost Pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { cb_sign_in(user) }

	describe "micropost creation" do
		before { visit root_path }

		describe "with invalid info" do
			it "should not create a micropost" do
				expect { click_button("Post") }.not_to change(Micropost, :count)
			end
		end

		describe "with valid info" do
			before { fill_in("Create a micropost", with: "Test micropost") }
			it "should create a micropost" do
				expect { click_button("Post") }.to change(Micropost, :count).by(1)
			end			
		end
	end

	describe "deleting microposts" do
		before { FactoryGirl.create(:micropost, user: user, content: "My cool micropost") }

		describe "as the user that created the micropost" do
			before { visit root_path }

			it "should delete the micropost" do
				expect { click_link("Delete") }.to change(Micropost, :count).by(-1)
			end	
		end

	end

end
