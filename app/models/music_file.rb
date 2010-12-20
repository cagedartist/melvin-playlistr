class MusicFile < ActiveRecord::Base
  belongs_to :user
  has_many :ratings, :dependent => :destroy
  has_many :raters, :through => :ratings, :source => :users

  def update_average_rating
    # Potential race conditions to be aware of. If a running tally is used, will need to use db transaction to prevent errors from accumulating.
    # re-computing the average every time is safe, albeit less efficient.
    self.average_rating = self.ratings(true).inject(0.0) { |sum, r| sum + r.value } / self.ratings.size
    save
  end
end
