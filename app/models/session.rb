# frozen_string_literal: true

class Session < ApplicationRecord
  has_many :timers, dependent: :destroy
  accepts_nested_attributes_for :timers

  has_many :asanas
  validates :name, presence: true
end
