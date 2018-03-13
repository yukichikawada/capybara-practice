class Goal < ApplicationRecord
  validates :task, :body, :user_id, presence: true

  has_many :comments
  belongs_to :user
end
