# frozen_string_literal: true

class Session < ApplicationRecord
  has_many :timers, dependent: :destroy
  has_many :asanas
  validates :name, presence: true
end
