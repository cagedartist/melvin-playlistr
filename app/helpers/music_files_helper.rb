module MusicFilesHelper
  # find or build user's rating for the given music file
  def fetch_current_user_rating(mf_id)
    current_user.ratings.find_by_music_file_id(mf_id) || current_user.ratings.build(:music_file_id => mf_id)
  end  
end
