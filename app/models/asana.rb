# frozen_string_literal: true

class Asana < ApplicationRecord
  belongs_to :session, optional: true
  has_many :timers, dependent: :nullify

  NUMBER_WORDS = %w[zero one two three four five six seven eight nine ten
                    eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty].freeze

  # Ordered: more specific patterns first ("half butterfly" before "butterfly").
  # ponytail: keyword table, swap for an explicit timer→asana picker in the UI when custom titles get creative.
  TITLE_PATTERNS = [
    [/anahatasana|melting heart/, "Anahatasana (Melting Heart)"],
    [/ankle stretch/, "Ankle Stretch"],
    [/bananasana/, "Bananasana"],
    [/half butterfly/, "Half Butterfly"],
    [/butterfly/, "Butterfly"],
    [/camel/, "Camel"],
    [/cat pulling/, "Cat Pulling Its Tail"],
    [/caterpillar/, "Caterpillar"],
    [/child/, "Child's Pose"],
    [/dangling/, "Dangling"],
    [/deer/, "Deer Pose"],
    [/winged dragon/, "Winged Dragon"],
    [/dragon/, "Dragons"],
    [/frog|tadpole/, "Frog"],
    [/happy baby/, "Happy Baby"],
    [/reclining twist|twisted roots|knee twist/, "Reclining Twist"],
    [/half saddle/, "Half Saddle"],
    [/saddle/, "Saddle"],
    [/sh?avasana/, "Shavasana"],
    [/shoelace/, "Shoelace"],
    [/snail/, "Snail"],
    [/sphinx/, "Sphinx and Seal"],
    [/seal/, "Seal"],
    [/square/, "Square"],
    [/toe squat/, "Toe Squat"],
    [/squat/, "Squat"],
    [/straddle|dragonfly/, "Straddle (Dragonfly)"],
    [/swan/, "Swan & Sleeping Swan"],
    [/bridge/, "Bridge (Supported Bridge)"]
  ].freeze

  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :benefits, presence: true, length: { minimum: 10 }
  validates :into_pose, presence: true, length: { minimum: 10 }
  validates :out_of_pose, presence: true, length: { minimum: 10 }
  validates :recommended_time, presence: true

  scope :for_session, ->(session_id) { where(session: session_id) }
  scope :standalone, -> { where(session: nil) }
  # LOWER/LIKE instead of ILIKE so search works on SQLite (dev/test) and Postgres (prod).
  scope :by_title, ->(title) { where("LOWER(title) LIKE ?", "%#{sanitize_sql_like(title.downcase)}%") }

  # Finds the library asana a timer/flow title refers to, e.g. "Straddle (left)" → "Straddle (Dragonfly)".
  def self.match_title(name)
    normalized = name.to_s.downcase
    library_title = TITLE_PATTERNS.find { |pattern, _| normalized.match?(pattern) }&.last
    find_by(title: name) || (library_title && find_by(title: library_title))
  end

  # Midpoint of the recommended range in seconds. "Three to five minutes." → 240, "30-60 sec" → 45.
  def duration_in_seconds
    return nil if recommended_time.blank?

    text = recommended_time.downcase.gsub(/\b(#{NUMBER_WORDS.join('|')})\b/) { NUMBER_WORDS.index(::Regexp.last_match(1)).to_s }
    numbers = text.scan(/\d+/).first(2).map(&:to_i)
    return nil if numbers.empty?

    unit = text.match?(/sec/) && !text.match?(/min/) ? 1 : 60
    (numbers.sum * unit) / numbers.size
  end

  def display_title
    title&.titleize
  end
end
