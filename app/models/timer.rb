# frozen_string_literal: true

class Timer < ApplicationRecord
  belongs_to :session
  belongs_to :asana, optional: true
  validates :duration, presence: true, numericality: { greater_than: 0 }

  before_save :link_asana, if: -> { asana_id.nil? && title.present? }

  private

  def link_asana
    self.asana = Asana.match_title(title)
  end
end
