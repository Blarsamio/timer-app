# frozen_string_literal: true

class Session < ApplicationRecord
  has_many :timers, -> { order(:position, :id) }, dependent: :destroy
  accepts_nested_attributes_for :timers

  has_many :asanas
  validates :name, presence: true
  validates :rebound_seconds, numericality: { only_integer: true, in: 0..300 }

  # Presets are shared and read-only; everything else belongs to the device that made it.
  def editable_by?(device_id)
    !preset? && device_id.present? && self.device_id == device_id
  end
end
