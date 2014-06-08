class User < ActiveRecord::Base
  attr_reader :password

  validates :name, :password_digest, :session_token, presence: true
  validates :name, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  has_many :subs, class_name: "Sub", foreign_key: :moderator_id,
           inverse_of: :moderator
  has_many :links,inverse_of: :user
  has_many :comments, inverse_of: :user

  def self.find_by_credentials(name, password)
    user = User.find_by_name(name)
    return nil unless user

    BCrypt::Password.new(user.password_digest).is_password?(password) ? user :nil
  end

  def password=(password)
    if password.present?
      @password = password
      self.password_digest = BCrypt::Password.create(password)
    end
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
end
