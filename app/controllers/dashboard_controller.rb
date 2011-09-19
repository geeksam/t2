class DashboardController < ApplicationController

  def index
    @current_tb   = TimeBlock.current
    @current_task = @current_tb.try(:task)

    @todays_tbs = TimeBlock.today.all

    # Summarize elapsed time for given periods
    sum_time = lambda { |finder, *args|
      period = args.first
      sum    = (TimeBlock.send(finder, *args).all || []).sum(&:elapsed_time)
      [period, sum]
    }
    weeks = [Week.for_date(Date.today)]
    (1..3).each do |i|
      weeks << weeks.last.prev
    end
    @time_summaries = {
      :today  => sum_time[:for_day,        Date.today],
      :last_0 => sum_time[:for_date_range, weeks[0]],
      :last_1 => sum_time[:for_date_range, weeks[1]],
      :last_2 => sum_time[:for_date_range, weeks[2]],
      :last_3 => sum_time[:for_date_range, weeks[3]],
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

  def update_cwo
    tb = TimeBlock.current
    attrs = params[:time_block]
    attrs[:ui_start_time] = Chronic.parse(attrs[:ui_start_time])
    tb.update_attributes(attrs)
    respond_to do |format|
      format.html { redirect_to dashboard_url }
      format.js   { render(:update) { |page| update_currently_working_on(page) }   }
    end
  end

  def new_tasks
    params[:new_tasks].each do |attrs|
      next unless attrs[:name].present?
      if attrs[:clock_in].present?
        clock_in = !!attrs.delete(:clock_in)
      end
      t = Task.create(attrs)
      t.clock_in! if clock_in
    end
    redirect_to dashboard_url
  end

end
