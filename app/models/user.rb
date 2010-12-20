class User < ActiveRecord::Base
  acts_as_authentic do |c|
    #c.validations_scope = :accountable_type
    c.require_password_confirmation=false
    c.validate_email_field = false
    #don't do magic and change the perishable token every time the Account is saved
    #this means we need to reset it ourselves.
    c.disable_perishable_token_maintenance = true
  end
  has_many :music_files, :dependent => :destroy
  has_many :ratings, :dependent => :destroy
  has_many :rated_music_files, :through => :ratings, :source => :music_files
  has_many :user_links
  has_many :friends, :through => :user_links, :source => :linked_user
    
  def admin?
    # TO DO: roles, maybe - or just a flag might be okay
    self.login == 'Bob'
  end
  
  # quick lookup of all friend ids
  def friend_ids
    self.user_links.collect{|f|f.linked_user_id}
  end
  
  def top_20
    eligible_ids = friend_ids << self.id
    MusicFile.find(:all, :conditions => {:user_id => eligible_ids}, :order => 'average_rating desc', :limit => 20)
  end
  
end
