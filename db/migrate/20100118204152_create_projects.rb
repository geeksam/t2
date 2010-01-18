class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.integer :client_id
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end