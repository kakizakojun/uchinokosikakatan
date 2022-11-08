# require "validators/attached_file_presence_validator"

class Post < ApplicationRecord
  scope :recent, -> {order(created_at: :desc)}

  has_many_attached :medias

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  after_create :generate_tag

  validates :medias, attached_file_presence: true




  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


  private

  def generate_tag
    post_names = Tag.tag_scan(caption)
    post_names.uniq.each do |word|
      self.tags << Tag.find_or_create_by(name: Tag.pound_delete_at_tag(word))
    end
  end

end
