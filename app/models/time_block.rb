# == Schema Information
#
# Table name: time_blocks
#
#  id         :integer         not null, primary key
#  task_id    :integer
#  date       :date
#  start_time :time
#  end_time   :time
#  notes      :text
#  created_at :datetime
#  updated_at :datetime
#

class TimeBlock < ActiveRecord::Base

  belongs_to :task
  
  default_scope :order => 'date desc, start_time desc, end_time desc'

  validates_presence_of :task
  
  named_scope :on_date,
              lambda { |date|
                { :conditions => ['time_blocks.date=?', date] }
              }
  #
  
  before_create :default_to_now
  def default_to_now
    self.date       ||= Date.today
    self.start_time ||= now
  end

end
