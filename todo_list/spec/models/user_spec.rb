require 'rails_helper'
require 'shoulda-matchers'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it { should validate_length_of(:password).is_at_least(6) }
  it { should have_many(:goals) }
  it { should have_many(:comments) }

  describe 'password encryption' do
    it 'does not save the password to the database' do
      User.create!(username: 'jack_bruce', password: 'abcdef')
      user = User.find_by(username: 'jack_bruce')
      expect(user.password).to_not eq('abcdef')
    end

    it 'encrypts the password using BCrypt' do
      expect(BCrypt::Password).to receive(:create)
      User.new(username: 'jack_bruce', password: 'abcdef')
    end

  end

  describe 'session_token' do
    it 'assigns a session token if one is not given' do
      jack = User.create(username: 'jack_bruce', password: 'abcdef')
      expect(jack.session_token).not_to be_nil
    end
  end
end
