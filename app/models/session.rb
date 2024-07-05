class Session < ApplicationRecord
  has_many :timers, dependent: :destroy
  validates :name, presence: true
end
