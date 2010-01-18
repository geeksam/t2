class CreateTimeBlocks < ActiveRecord::Migration
  def self.up
    create_table :time_blocks do |t|
      t.integer :task_id
      t.date :date
      t.time :start_time
      t.time :end_time
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :time_blocks
  end
end
