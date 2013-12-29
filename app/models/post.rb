class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  attr_accessible :title, :body

  default_scope order('created_at DESC')
end
