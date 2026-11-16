class AddSegmentFieldsToTimers < ActiveRecord::Migration[7.1]
  def up
    add_column :timers, :position, :integer, null: false, default: 0
    add_column :timers, :kind, :string, null: false, default: "pose"
    add_column :timers, :side, :string
    add_index :timers, [:session_id, :position]
    add_column :sessions, :rebound_seconds, :integer, null: false, default: 45

    # Existing order was implicit by id; kind/side come from title/instruction.
    Timer.reset_column_information
    Timer.order(:session_id, :id).group_by(&:session_id).each_value do |timers|
      timers.each_with_index do |timer, index|
        timer.update_columns(position: index + 1, kind: Timer.kind_for(timer.title), side: Timer.side_for(timer.instruction, timer.title))
      end
    end
  end

  def down
    remove_index :timers, [:session_id, :position]
    remove_column :timers, :position
    remove_column :timers, :kind
    remove_column :timers, :side
    remove_column :sessions, :rebound_seconds
  end
end
