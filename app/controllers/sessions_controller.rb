class SessionsController < ApplicationController

	def new
		@email = ""
		@password = ""
	end

	def create
		user = User.find_by(email: params[:session][:email])

		if user && user.authenticate(params[:session][:password])
			redirect_to(user)
		else
			flash.now[:error] = "Invalid username/password."
			render 'new'
		end
	
	end

	def destroy
	end
end
