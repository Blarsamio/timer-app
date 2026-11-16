class AsanaBlueprint < ApplicationBlueprint
  identifier :id
  fields :title, :benefits, :recommended_time, :min_seconds, :max_seconds, :default_seconds,
         :contraindications, :alternatives_and_options, :counterposes, :meridians_and_organs, :joints,
         :into_pose, :out_of_pose, :other_notes, :similar_yang_asanas,
         :created_at, :updated_at, :session_id
end
