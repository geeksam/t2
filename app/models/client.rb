# == Schema Information
#
# Table name: clients
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  active     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Client < ActiveRecord::Base
  has_many :projects, :order => 'projects.name'
  
  default_scope :order => 'clients.name'
  
  named_scope :active,
              :conditions => ['active']

end
