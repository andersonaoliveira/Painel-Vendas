class Client < ApplicationRecord
  include ActiveModel::Validations
  enum eni_status: { inactive: 0, active: 1 }

  has_many :orders, dependent: nil

  validates :eni, :name, :email, presence: true
  # rubocop:disable all
  validates :eni, uniqueness: true
  # rubocop:enable all
  validates :eni, eni: true
  validates :eni, format: { with: /\A[0-9]+\z/, message: 'Somente números' }
end
