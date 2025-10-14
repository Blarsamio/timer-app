class Asana < ApplicationRecord
  belongs_to :session, optional: true

  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :benefits, presence: true, length: { minimum: 10 }
  validates :into_pose, presence: true, length: { minimum: 10 }
  validates :out_of_pose, presence: true, length: { minimum: 10 }
  validates :recommended_time, presence: true

  scope :for_session, ->(session_id) { where(session: session_id) }
  scope :standalone, -> { where(session: nil) }
  scope :by_title, ->(title) { where('title ILIKE ?', "%#{title}%") }

  def duration_in_seconds
    return nil unless recommended_time

    case recommended_time.downcase
    when /(\d+)\s*min/
      $1.to_i * 60
    when /(\d+)\s*sec/
      $1.to_i
    when /(\d+)-(\d+)\s*min/
      ($1.to_i + $2.to_i) / 2 * 60
    else
      nil
    end
  end

  def display_title
    title&.titleize
  end
end
