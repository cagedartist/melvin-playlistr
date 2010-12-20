class CreateMusicFiles < ActiveRecord::Migration
  def self.up
    create_table :music_files do |t|
      t.string :url
      t.string :title
      t.string :artist_name
      t.integer :duration
      t.float :average_rating
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :music_files
  end
end
