class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :follow_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :follows, through: :follow_relationships, source: :followed
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :followed_relationships, source: :follower
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user)
    follow_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    follow_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    follows.include?(user)
  end

  def self.search_for(method, word)
    if method == "perfect_match"
      User.where("name LIKE?", "#{word}")
    elsif method == "forward_match"
      User.where("name LIKE?","#{word}%")
    elsif method == "backward_match"
      User.where("name LIKE?","%#{word}")
    elsif method == "partial_match"
      User.where("name LIKE?","%#{word}%")
    else
      User.all
    end
  end
end
