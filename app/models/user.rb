# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  login             :string(255)
#  display_name      :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic  # use authlogic
end
