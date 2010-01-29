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

  def self.active_list_by_project
    active.group_by(&:project).sort_by { |a| a.first.name }
  end

  before_create :make_active
  def make_active
    self.active = true
  end

  def project_name
    project.try(:name)
  end

  def display_name
    returning "" do |s|
      s << name[0..50]
      s << '...' if name.length > 50
      s << " (#{project.name})" if project
    end
  end

  def current_tb
    TimeBlock.current.first
  end

  def clock_in!
    tb = current_tb
    unless tb.nil?
      tb.end_time = Time.now
      tb.save
    end
    TimeBlock.create(:task => self)
  end

  def clock_out!
    return unless is_current?  #temp: consider raising an error?
    current_tb.stop_clock!
  end

  def is_current?
    self == current_tb.task
  end

end
