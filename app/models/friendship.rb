class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'


  validate :users_friends

  private

  def users_friends
    if User.where(user_id: friend_id, friend_id: user_id).or(User.where(user_id: user_id, friend_id: friend_id)).exists?
      errors.add(:user_id, 'Already friends!')
    end
  end

end
