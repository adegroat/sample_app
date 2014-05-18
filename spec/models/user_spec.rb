require 'spec_helper'

describe User do
	before { @user = User.new(name: "Test user", email: "user@mail.com") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }

	it { should be_valid }

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

	describe "when email is not valid" do
		it "should be invalid" do
			emails = ["test@mail", "monkyrubeATgmail.com", "email"]
			emails.each do |invalid_email|
				@user.email = invalid_email
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email is valid" do
		it "should be valid" do
			emails = ["alex@email.com", "bob.UIilder21@gAIil.tk", "fish_bait.s@mail.org"]
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
end