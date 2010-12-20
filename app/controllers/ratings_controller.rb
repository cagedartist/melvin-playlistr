class RatingsController < ApplicationController
  before_filter :require_user  
  before_filter :check_if_friends_file  
  
  def create
    @rating = Rating.new(params[:rating])
    @rating.music_file = @music_file
    @rating.user = current_user
    if @rating.save
      respond_to do |format|
        format.html { redirect_to user_path(@music_file.user), :notice => "Your rating has been saved" }
        format.js
      end
    end
  end

  def update
    @rating = current_user.ratings.find_by_music_file_id(@music_file.id)
    # cache objects in rating record (will not cause a change ...will make after_save more efficient)
    @rating.music_file = @music_file
    @rating.user = current_user
    if @rating.update_attributes(params[:rating])
      respond_to do |format|
        format.html { redirect_to user_path(@music_file.user_id), :notice => "Your rating has been updated" }
        format.js
      end
    end
  end

private
  def check_if_friends_file
    @music_file = MusicFile.find_by_id(params[:music_file_id])
    friend_ids = current_user.friend_ids
    unless current_user.id == @music_file.user_id || friend_ids.include?(@music_file.user_id)
      redirect_to user_path(@music_file.user_id), :notice => "Only friend's music files can be rated."
      return false
    end
    true
  end
end
