class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :omniauthable

  devise :timeoutable, timeout_in: 24.hours

  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
end
