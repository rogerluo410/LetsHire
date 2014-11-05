class OpeningParticipant < ActiveRecord::Base
  belongs_to :participant, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :opening
  validates :user_id, :uniqueness => { :scope => :opening_id }
end
