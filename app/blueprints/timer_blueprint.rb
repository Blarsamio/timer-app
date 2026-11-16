class TimerBlueprint < ApplicationBlueprint
  identifier :id
  fields :title, :duration, :session_id, :asana_id, :instruction, :counterpose, :position, :kind, :side, :created_at, :updated_at
end
