class DashboardController < ApplicationController

  def index
    @current_tb   = TimeBlock.current.first
    @current_task = @current_tb.try(:task)

    @todays_tbs = TimeBlock.today.all
  end

end
