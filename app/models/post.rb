class Post < ActiveRecord::Base
  attr_accessible :title, :body, :topic
  has_many :comments
  belongs_to :user
  belongs_to :topic

  default_scope order('created_at DESC')
end
