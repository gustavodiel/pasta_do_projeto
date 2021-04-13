class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true

  has_many :images

  def generate_token
    JWT.encode(
      {
        id: id,
        exp: 1.week.from_now.to_i,
      },
      Rails.application.secret_key_base
    )
  end
end
