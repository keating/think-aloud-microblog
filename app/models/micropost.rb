class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content, :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true

  default_scope :order => 'microposts.created_at desc'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  def self.followed_by(user)
    following_ids = %(select followed_id from relationships
           where follower_id = :user_id)
    where("user_id in (#{following_ids}) or user_id = :user_id",
          {:user_id => user})
  end
end
