# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  provider    :string(255)
#  uid         :string(255)
#  name        :string(255)
#  oauth_token :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  email       :string(255)
#

class User < ActiveRecord::Base
  has_many :participations
  has_many :challenges, through: :participations
  has_many :roles
  has_many :owned_challenges,
    foreign_key: :user_id,
    class_name: :Challenge

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.save!
    end
  end

  def gravatar_url(size = 48)
    gravatar_id = Digest::MD5.hexdigest(email || '')
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def role_symbols
    (roles || []).map {|r| r.title.to_sym} << :user
  end
end
