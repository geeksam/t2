class ReportsController < ApplicationController

  def hours_by_day
    tbs = time_block_finder.all({
      :include => { :task => :project },
      :order   => 'time_blocks.date DESC, projects.name, tasks.name',
    })
    @days_and_tbs = tbs.group_by(&:date)
  end

  def unused_tasks
    @empty_tasks = Task.empty.all(:include => [:project], :order => 'projects.name, tasks.name')
  end


  protected
  def time_block_finder
    # By default, get last ten days
    a = params[:start_date] || 9.days.ago.to_date # (yes, 9 = 10)
    b = params[:end_date]   || Date.today

    finder = TimeBlock
    finder = finder.for_dates(a, b)
    finder = finder.for_client(params[:client_id])    if params[:client_id].present?
    finder = finder.for_project(params[:project_id])  if params[:project_id].present?
    finder
  end

end
