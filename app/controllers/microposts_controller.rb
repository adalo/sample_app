class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@micropost = current_user.microposts.build(micropost_params)
		# the following should be refactored out of the create method
		# first check the content and see if it's an @reply
		if @micropost.content[0] === "@"
			# so it is! now we split the reply on the @
			split_content = @micropost.content.split('@')
			# since the first char was an @, the second element of the split_content array should start with the username
			# knowing that, we can split that string on spaces to get the usename (this assumes usenames can't have spaces)
			username = split_content[1].split(' ')[0]
			# now we find the user by their username
			recipient = User.find_by_username(username)
			# flash an error if the username didn't return a user, otherwise set user's id as the micropost's in_reply_to
			if recipient === nil
				flash[:error] = "Oops! We can't send a reply to @#{username} because that username does not exist."
				redirect_to root_url and return
			else
				@micropost.in_reply_to = recipient.id
			end					
		end

		if @micropost.save
		flash[:success] = "Micropost created!"
		redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private

	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user
		@micropost = current_user.microposts.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end
end