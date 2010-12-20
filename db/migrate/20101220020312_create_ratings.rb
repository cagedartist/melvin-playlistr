class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.references :user
      t.references :music_file
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
