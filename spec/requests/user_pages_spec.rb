require 'spec_helper'

describe "User pages" do

	subject { page }
  	
	describe "sign up page" do
		before { visit signup_path }
		it { should have_content('Sign up') }
		it { should have_title(correct_title('Sign up')) }
	end

end
