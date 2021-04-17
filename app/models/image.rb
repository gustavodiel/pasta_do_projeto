class Image < ApplicationRecord
  validates :title, presence: true

  has_one_attached :file
  belongs_to :user
end
