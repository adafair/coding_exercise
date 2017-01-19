class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :organization, null: false
      t.string :message, null: false
      t.string :hostname, null: false
      t.timestamps
    end
  end
end
