class DashboardController < ApplicationController

  def index
    @current_tb   = TimeBlock.current.first
    @current_task = @current_tb.try(:task)
  end

end
