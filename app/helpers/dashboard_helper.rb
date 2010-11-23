module DashboardHelper
  def update_panel(page, panel_name, options_for_replace_html = {})
    options_for_replace_html.reverse_merge(:partial => panel_name)
    page.replace_html panel_name, options_for_replace_html
    page.visual_effect :highlight, panel_name
  end

  def update_time_summaries(page)
    update_panel page, 'time_summaries',
      :object => @time_summaries,
      :locals => { :client => @client }
  end

  def update_currently_working_on(page)
    # Note that this is destructive of edits made in the "Currently Working On" panel.
    update_panel page, 'currently_working_on',
      :locals => { :current_tb => TimeBlock.current }
  end

  def display_edit_ttbs_form(page)
    update_panel page, 'todays_time_blocks',
      :partial => 'todays_time_blocks_edit',
      :locals  => { :tbs => TimeBlock.today.all }
  end

  def display_show_ttbs_form(page)
    update_panel page, 'todays_time_blocks',
      :partial => 'todays_time_blocks_show',
      :locals  => { :tbs => TimeBlock.today.all }
  end
end
