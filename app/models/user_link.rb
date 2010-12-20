class UserLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :linked_user, :class_name => 'User'
end
