class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { minimum: 6 }, uniqueness: true

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships

  has_many :pending_friendships, -> { where status: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  has_many :inverse_friendships, -> { where status: false }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverse_friendships, source: :user

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.status }
    friends_array.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find_by(user_id: user.id)
    friendship.status = true
    friendship.save
  end

  def reject_friend(user)
    friendship = inverse_friendships.find_by(user_id: user.id)
    friendship.destroy
  end

  def cancel_request(user)
    friendship = friendships.find_by(friend_id: user.id)
    friendship.destroy
  end

  def friend?(user)
    friends.include?(user)
  end
end
