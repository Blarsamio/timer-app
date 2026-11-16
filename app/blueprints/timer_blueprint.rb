class TimerBlueprint < ApplicationBlueprint
  identifier :id
  fields :title, :duration, :session_id, :asana_id, :instruction, :counterpose, :created_at, :updated_at
end
