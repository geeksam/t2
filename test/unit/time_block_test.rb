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

require 'test_helper'

class TimeBlockTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
