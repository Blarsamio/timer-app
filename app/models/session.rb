# frozen_string_literal: true

class Session < ApplicationRecord
  has_many :timers, dependent: :destroy
  accepts_nested_attributes_for :timers

  has_many :asanas
  validates :name, presence: true

  # Presets are shared and read-only; everything else belongs to the device that made it.
  def editable_by?(device_id)
    !preset? && device_id.present? && self.device_id == device_id
  end
end
