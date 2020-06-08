require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:example) do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user, email: 'apple2@gmail.com', name: 'User2')
  end
  describe 'associations' do
    it { should belong_to(:friend).class_name('User') }
    it { should belong_to(:user) }
  end

  describe 'validation' do
    it 'validates that friendship is valid' do
      f = Friendship.new(user_id: @user1.id, friend_id: @user2.id, status: false)
      f.save
      f.update(status: true)
      f.valid?
    end

    it 'validates that user and friend are not same' do
      f = Friendship.new(user_id: @user1.id, friend_id: @user1.id, status: true)
      f.save
      expect(f).to be_invalid
      expect(f.errors[:base]).to include('Already friends!')
    end

    it 'validates that friendship already exists' do
      f1 = Friendship.new(user_id: @user1.id, friend_id: @user2.id, status: false)
      f1.save
      f1.update(status: true)
      f2 = Friendship.new(user_id: @user1.id, friend_id: @user2.id, status: true)
      f2.save
      expect(f2).to be_invalid
      expect(f2.errors[:base]).to include('Already friends!')
    end
  end
end
