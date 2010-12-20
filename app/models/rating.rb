class Rating < ActiveRecord::Base  
  belongs_to :user
  belongs_to :music_file
  after_save :update_average
  after_destroy :update_average

private 
  def update_average
    # Potential efficiency issues, here. May want to cache ratings for music file. Backgrounding not advised because UI should reflect change immediately.
    self.music_file.update_average_rating
  end
    
end
