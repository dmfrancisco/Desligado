class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :uuid
      t.text :category
      t.boolean :dirty,   :default => false
      t.boolean :deleted, :default => false
      t.timestamps
    end

    change_table :items do |t|
      t.index :created_at
    end
  end

  def self.down
    drop_table :items
  end
end
