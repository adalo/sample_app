class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

	#Returns microposts from the users being followed by the given user except those that are replies to another user
	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
	where("(user_id IN (#{followed_user_ids}) AND (in_reply_to IS NULL OR in_reply_to = :user_id)) OR user_id = :user_id", user_id: user.id)
	end
end