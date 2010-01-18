# == Schema Information
#
# Table name: tasks
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  project_id :integer
#  ticket_no  :string(255)
#  notes      :text
#  active     :boolean         default(TRUE)
#  recurring  :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Task < ActiveRecord::Base

  belongs_to :project
  has_many :time_blocks, :order => 'date desc, start_time desc, end_time desc'

  default_scope :order => 'tasks.name'

  named_scope :active,
              :conditions => ['tasks.active']
  named_scope :sort_by_name,
              :order => 'tasks.name'

  before_create :make_active
  def make_active
    self.active = true
  end

end
