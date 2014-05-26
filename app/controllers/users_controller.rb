class UsersController < ApplicationController

	def new
		@user = User.new

		if signed_in?
			redirect_to(current_user, notice: "You already have an account.")
		end

	end

	def create
		@user = User.new(user_params())

		if @user.save
			sign_in(@user)
			flash[:success] = "Thank you for signing up!"
			redirect_to(@user)
		else
			render('new')
		end

	end

	def show
		@user = User.find_by(id: params[:id])
	end

private 

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

end
