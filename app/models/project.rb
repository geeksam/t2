# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  client_id  :integer
#  active     :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#  short_name :string(255)
#

class Project < ActiveRecord::Base
  
  belongs_to :client
  has_many :tasks
  has_many :active_tasks, :class_name => 'Task', :conditions => { :active => true }
  has_many :time_blocks, :through => :tasks, :order => 'date desc, start_time desc, end_time desc'

  default_scope :order => 'projects.name'
  
  named_scope :active,
              :conditions => ['active'],
              :order      => 'projects.name'
  named_scope :with_active_tasks,
              :conditions => ['tasks.active'],
              :include    => [:tasks],
              :order      => 'projects.name'
  named_scope :for_client,
              lambda { |client|
                { :conditions => ['projects.client_id=?', client.to_param] }
              }
  #

  # def active_tasks
  #   tasks.select(&:active?).sort_by { |e| e.name.downcase }
  # end

  # def tasks_most_recent_first
  #   tasks.sort_by {|e| e.time_blocks.first }.reverse
  # end

  def client_name
    client.try(:name)
  end

  def short_name
    read_attribute(:short_name) || read_attribute(:name)
  end

end
