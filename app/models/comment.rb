class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_many :notifications, dependent: :destroy

  validates :comment, presence: true

  def create
  end

end
