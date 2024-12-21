class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]


  has_one_attached :avatar
  enum role: [:admin, :artist, :listener]
  after_initialize :set_default_role, if: :new_record?

  def self.from_omniauth(access_token)
    data = access_token.info
    account = User.where(email: data['email']).first

    # Create account if it doesn't exist
    unless account
      account = User.create(
        name: data['name'],
        email: data['email'],
        password: Devise.friendly_token[0, 20]
      )
    end

    # Handle avatar attachment
    if data['image'].present?
      attach_google_avatar(account, data['image'])
    end

    account
  end

  private

  def self.attach_google_avatar(user, image_url)
    require 'open-uri'
    
    begin
      filename = "avatar_#{Time.current.to_i}.jpg"
      avatar_file = URI.open(image_url)
      
      user.avatar.attach(
        io: avatar_file,
        filename: filename,
        content_type: 'image/jpeg'
      )
    rescue OpenURI::HTTPError => e
      Rails.logger.error "Failed to download avatar: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Error processing avatar: #{e.message}"
    end
  end

  def set_default_role
    self.role ||= :listener
  end

end
