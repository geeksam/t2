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
    if params[:for_date]
      a, b = params[:for_date], params[:for_date]
    else
      num_days = 30
      a = params[:start_date] || (num_days-1).days.ago.to_date
      b = params[:end_date]   || Date.today
    end

    finder = TimeBlock
    finder = finder.for_dates(a, b)
    finder = finder.for_client(params[:client_id])    if params[:client_id].present?
    finder = finder.for_project(params[:project_id])  if params[:project_id].present?
    finder
  end

end
