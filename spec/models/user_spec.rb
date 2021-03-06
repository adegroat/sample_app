require 'spec_helper'

describe User do
	before { @user = User.new(name: "Test user", email: "user@mail.com", password: "monkey", password_confirmation: "monkey") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }

	it { should be_valid }
	it { should_not be_admin }


	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it {should_not be_valid}
	end


	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when email is invalid" do
		it "should be invalid" do
			emails = ["test@mail", "monkyrubeATgmail.com", "email", "bob@mail..com"]
			emails.each do |invalid_email|
				@user.email = invalid_email
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email is valid" do
		it "should be valid" do
			emails = ["alex@email.com", "bob.bUIlder21@gmAIl.tk", "fish_bait.s@mail.org"]
			emails.each do |valid_email|
				@user.email = valid_email
				expect(@user).to be_valid
			end
		end
	end

	describe "when email is already taken" do
		before do
			dupe_user = @user.dup
			dupe_user.email = @user.email.upcase
			dupe_user.save
		end
		it { should_not be_valid }
	end


	describe "when password is not present" do		
		before { @user.password = @user.password_confirmation = "" }
		it { should_not be_valid }
	end

	describe "when password confirmation doesn't match password" do
		before { @user.password_confirmation = "something_invalid" }
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) {User.find_by(email: @user.email)}

		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) {found_user.authenticate("WRONG_PASSWORD")}
			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

	describe "remember token" do
		before { @user.save }
		its (:remember_token) { should_not be_blank }
	end

	describe "with admin status" do
		before do
			@user.save!
			@user.toggle(:admin)
		end
		it { should be_admin }
	end

	describe "micropost association" do
		before { @user.save }
		let!(:older_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
		let!(:newer_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }

		it "should have the micropost in the correct order(newest to last)" do
			expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
		end

		it "should destroy microposts when their associated user is destroyed" do
			microposts = @user.microposts.to_a
			@user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |mp|
				expect(Micropost.where(id: mp.id)).to be_empty
			end
		end

		describe "status" do
			let(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
			
			its(:feed) { should include(newer_micropost) }
			its(:feed) { should include(older_micropost) }
			its(:feed) { should_not include(unfollowed_post) }
		end

	end

end