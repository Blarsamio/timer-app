class SessionBlueprint < ApplicationBlueprint
  identifier :id
  fields :name, :description, :created_at, :updated_at, :device_id

  view :with_timers do
    association :timers, blueprint: TimerBlueprint
  end

  view :with_asanas do
    association :asanas, blueprint: AsanaBlueprint
  end
end
