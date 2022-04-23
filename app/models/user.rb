class User < ApplicationRecord
  has_many :commissions, dependent: :destroy

  enum role: { salesperson: 0, admin: 1 }
  enum status: { inactive: 0, active: 1 }

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A.+@locaweb.com.br\z/, message: 'O e-mail deve pertencer à Locaweb' }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
