class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validate :users_friends

  after_update :create_reverse_friendship

  private

  def users_friends
    # rubocop:disable Layout/LineLength
    errors.add(:base, 'Already friends!') if (Friendship.where(user_id: friend_id, friend_id: user_id, status: true).exists? && Friendship.where(user_id: user_id, friend_id: friend_id, status: true).exists?) || user_id == friend_id
  end

  def create_reverse_friendship
    reverse_fs = Friendship.new(user_id: friend_id, friend_id: user_id, status: true)
    reverse_fs.save
    # rubocop:enable Layout/LineLength
  end
end
