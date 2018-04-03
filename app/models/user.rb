class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  
  # Regex explaination below
  # / : 	start of regex | \A : match start of a string
  # [\w+\-.]+ : at least one word character, plus, hyphen, or dot
  # @ : literal “at sign” | [a-z\d\-.]+ : at least one letter, digit, hyphen, or dot
  # \. : literal dot | [a-z]+ : at least one letter
  # \z : match end of string | / : end of regex
  # i :  case-insensitive
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
 
 has_secure_password
 validates :password, presence: true, length: { minimum: 6 }
 
 #Returns a hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token with the length 22. It has characters A-Z a-z 0-9 and "-" "_"
  # This also has 64 different possibiltiies
  # Stops cookies from being stolen by stored a hash digest instead of the remember token
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remember a user in the database for use in persistent sessions
  def remember
    self.remember_token =  User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end
                    
end
