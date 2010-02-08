class DashboardController < ApplicationController

  def index
    @current_tb   = TimeBlock.current.first
    @current_task = @current_tb.try(:task)

    @todays_tbs = TimeBlock.today.all

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


  ##### Time block management: these are AJAX only, and use methods from DashboardHelper
  def edit_todays_tbs
    render(:update) { |page| display_edit_ttbs_form(page) }
  end
  def cancel_editing_todays_tbs
    render(:update) { |page| display_show_ttbs_form(page) }
  end
  def show_todays_tbs
    render(:update) { |page| display_show_ttbs_form(page); update_currently_working_on(page) }
  end


  def update_tbs
    redirect_to dashboard_url and return unless request.post?

    params[:time_blocks].each do |id, attrs|
      tb = TimeBlock.find(id)
      if attrs[:delete].present?
        tb.destroy
      else
        attrs[:start_time] = Chronic.parse(attrs[:start_time])
        attrs[:end_time  ] = Chronic.parse(attrs[:end_time  ])
        tb.update_attributes(attrs)
      end
    end

    respond_to do |wants|
      wants.html { redirect_to dashboard_path }
      wants.js { show_todays_tbs }
    end
  end


  ##### Reporting

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
