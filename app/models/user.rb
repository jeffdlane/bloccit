class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar, :provider, :uid, :email_favorites
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  before_create :set_member
  mount_uploader :avatar, AvatarUploader

  def self.find_for_facebook_oauth(auth,signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if not user
      pass = Devise.friendly_token[0,20]
      user = User.new(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: pass,
        )
      user.skip_confirmation!
      user.save!
    end
    user
  end

  def self.top_rated
    self.select('users.*'). #Select all attributes of the user
    select('COUNT(DISTINCT comments.id) AS comments_count'). #Count the comments made by the user 
    select('COUNT(DISTINCT posts.id) AS posts_count'). #Count the posts made by the user
    select('COUNT(DISTINCT comments.id) + COUNT(DISTINCT posts.id) AS rank'). #Add the count of comments to the count of posts
    joins(:posts). #Ties the posts table to the users table, via the user_id
    joins(:comments). #Ties the comments table to the users table, via the user_id
    group('users.id'). #Instructs the db to group the results so that each user will be returned in its own row
    order('rank DESC') #Order the results in descending order by rank
  end
  
  ROLES = %w[member moderator admin]

  def role?(base_role)
   role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def favorited(post) #should it be 'favorited?'
    self.favorites.where(post_id: post.id).first
  end

  def voted(post)
    self.votes.where(post_id: post.id).first
  end
  

private

  def set_member
    self.role = 'member'
  end

end