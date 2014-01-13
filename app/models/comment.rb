class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  attr_accessible :body

  after_create :send_favorite_emails

  validates :body, length: { minimum: 1 }, presence: true
  validates :post, presence: true
  validates :user, presence: true

private
  def send_favorite_emails
    # for every favorite associated with post, send email
    self.post.favorites.each do |favorite|
      if favorite.user_id != self.user_id && favorite.user.email_favorites?
      FavoriteMailer.new_comment(favorite.user, self.post, self).deliver
      end
    end
  end
end
