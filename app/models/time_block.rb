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

  named_scope :for_day,
              lambda { |date|
                { :conditions => ['time_blocks.date=?', date] }
              }
  named_scope :for_week,
              lambda { |date|
                { :conditions => ['time_blocks.date BETWEEN ? AND ?', date.beginning_of_week, date.end_of_week] }
              }
  named_scope :for_date_range,
              lambda { |pp|
                { :conditions => ['time_blocks.date BETWEEN ? AND ?'] + pp.boundaries }
              }
  named_scope :for_dates,
              lambda { |start_date, end_date|
                { :conditions => ['time_blocks.date BETWEEN ? AND ?', start_date, end_date] }
              }
  named_scope :today,
              :conditions => ['time_blocks.date=?', Date.today]
  named_scope :is_current,
              :conditions => ['end_time IS NULL']
  named_scope :for_task,
              lambda { |task|
                { :conditions => ['time_blocks.task_id=?', task.to_param] }
              }
  named_scope :for_project,
              lambda { |project|
                {
                  :include    => [:task],
                  :conditions => ['tasks.project_id=?', project.to_param]
                }
              }
  named_scope :for_client,
              lambda { |client|
                {
                  :include    => {:task => :project},
                  :conditions => ['projects.client_id=?', client.to_param]
                }
              }
  #
  def self.current
    is_current.first
  end

  before_create :default_to_now
  def default_to_now
    self.date       ||= Date.today
    self.start_time ||= TIME_CLASS.now
  end

  def task_name
    task.try(:name)
  end
  def project_name
    task.try(:project).try(:name)
  end
  def proj_name
    task.try(:project).try(:short_name)
  end


  def end_time_or_now
    end_time || TIME_CLASS.now
  end

  def elapsed_time
    return 0 if start_time.nil?
    seconds = end_time_or_now - start_time
    if seconds > 10.hours # hours, that is
      raise ['end time -->', end_time_or_now.to_s, 'start time -->', start_time.to_s].inspect
    end
    return seconds / 1.hour
  end
  alias :hours :elapsed_time


  def stop_clock!
    self.end_time = TIME_CLASS.now
    save
  end


  # Have experienced some difficulty getting times to match up between
  # Time and Time.zone.  Thus, I'm explicitly using Time -- as I run
  # this app locally, I don't need the bother.
  TIME_CLASS = Time

  def start_time
    reparse_time(read_attribute(:start_time))
  end
  def start_time=(time)
    write_attribute :start_time, reparse_time(time)
  end
  def end_time
    reparse_time(read_attribute(:end_time))
  end
  def end_time=(time)
    write_attribute :end_time, reparse_time(time)
  end

  protected
  def reparse_time(time)
    return if time.blank?
    TIME_CLASS.parse(time.strftime('%H:%M:%S'))
  end

end
