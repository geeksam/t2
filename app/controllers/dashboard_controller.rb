class DashboardController < ApplicationController

  def index
    @current_tb   = TimeBlock.current.first
    @current_task = @current_tb.try(:task)

    # Summarize elapsed time for given periods
    sum_time = lambda { |finder, *args|
      period = args.first
      sum    = (TimeBlock.send(finder, *args).all || []).sum(&:elapsed_time)
      [period, sum]
    }
    @time_summaries = {
      :today         => sum_time[:for_day,        Date.today],
      :this_week     => sum_time[:for_week,       Date.today],
      :this_pp       => sum_time[:for_pay_period, PayPeriod.current],
      :last_pp       => sum_time[:for_pay_period, PayPeriod.last_but(0)],
      :last_pp_but_1 => sum_time[:for_pay_period, PayPeriod.last_but(1)],
      :last_pp_but_2 => sum_time[:for_pay_period, PayPeriod.last_but(2)],
    }
  end

  def hours_by_day
    @time_blocks = finder_for_report.all({
      :include => { :task => :project },
      :order   => 'time_blocks.date DESC, projects.name, tasks.name',
    })
  end


  protected
  def finder_for_report
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
