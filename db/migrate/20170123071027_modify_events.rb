class ModifyEvents < ActiveRecord::Migration[5.0]
  def change
    # According to the instructions it seems like the timestamp for each event
    # should be able to be specified by the caller, not automatically set to
    # the time the event is received by this application. This will add a new
    # field for that purpose and remove created_at and updated_at since those
    # are not required.
    remove_column :events, :created_at
    remove_column :events, :updated_at
    add_column :events, :timestamp, :datetime, null: false

    add_index :events, :timestamp

    # Add an index for hostname since we allow caller's to filter by hostname in
    # the events controller.
    add_index :events, :hostname
  end
end
