class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  
  has_many :notifications, dependent: :destroy
  
  def create
  end

end
