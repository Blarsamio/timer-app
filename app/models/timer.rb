# frozen_string_literal: true

class Timer < ApplicationRecord
  KINDS = %w[pose rebound counterpose centering savasana closing].freeze
  SIDES = %w[left right].freeze

  belongs_to :session
  belongs_to :asana, optional: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :kind, inclusion: { in: KINDS }
  validates :side, inclusion: { in: SIDES }, allow_nil: true

  before_save :link_asana, if: -> { asana_id.nil? && title.present? }
  before_create :infer_segment_fields

  # ponytail: title keywords; replace with an explicit kind picker in the builder.
  def self.kind_for(title)
    case title.to_s.downcase
    when /switch pose|rebound/ then "rebound"
    when /s?h?avasana/ then "savasana"
    when /finishing meditation|closing meditation/ then "closing"
    when /meditation/ then "centering"
    else "pose"
    end
  end

  # First side word in the cue, else in the title: "Left knee on top" → left,
  # "right arm under left" → right, "Bananasana to the right" → right.
  def self.side_for(instruction, title = nil)
    [instruction, title].each do |text|
      side = text.to_s.downcase[/\b(left|right)\b/, 1]
      return side if side
    end
    nil
  end

  private

  def link_asana
    self.asana = Asana.match_title(title)
  end

  def infer_segment_fields
    self.kind = self.class.kind_for(title) if kind == "pose"
    self.side ||= self.class.side_for(instruction, title)
    self.position = (session.timers.maximum(:position) || 0) + 1 if position.to_i.zero?
  end
end
