# frozen_string_literal: true

class Timer < ApplicationRecord
  belongs_to :session
  validates :duration, presence: true, numericality: { greater_than: 0 }
end
