class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.integer :project_id
      t.string :ticket_no
      t.text :notes
      t.boolean :active, :default => true
      t.boolean :recurring

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
