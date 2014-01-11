class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar, :provider, :uid
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  before_create :set_member
  mount_uploader :avatar, AvatarUploader

  ROLES = %w[member moderator admin]

  def role?(base_role)
   role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

private

def set_member
  self.role = 'member'
end

end