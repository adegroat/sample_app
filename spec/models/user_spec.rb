require 'spec_helper'

describe User do
	before { @user = User.new(name: "Test user", email: "user@mail.com", password: "monkey", password_confirmation: "monkey") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }

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

	describe "when email is invalid" do
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
		before { @user = User.new(name: "TestUser", email: "test@mail.com", password: "", password_confirmation: "") }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation = "something_invalid"}
		it {should_not be_valid}
	end

	describe "with a password that's too short" do
		before {@user.password = @user.password_confirmation = "a" * 5}
		it {should be_invalid}
	end

	describe "return value of authenticate method" do
		before {@user.save}
		let(:found_user) {User.find_by(email: @user.email)}

		describe "with valid password" do
			it {should eq found_user.authenticate(@user.password)}
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) {found_user.authenticate("WRONG_PASSWORD")}
			it {should_not eq user_for_invalid_password}
			specify { expect(user_for_invalid_password).to be_false }
		end
	end
end