module DashboardHelper
  def update_currently_working_on(page)
    # Note that this is destructive of edits made in the "Currently Working On" panel.
    page.replace_html 'currently_working_on',
                      :partial => 'currently_working_on',
                      :locals  => { :current_tb => TimeBlock.current }
    page.visual_effect :highlight, 'currently_working_on'
  end
  def display_edit_ttbs_form(page)
    page.replace_html 'todays_time_blocks',
                      :partial => 'todays_time_blocks_edit',
                      :locals  => { :tbs => TimeBlock.today.all }
    page.visual_effect :highlight, 'todays_time_blocks'
  end
  def display_show_ttbs_form(page)
    page.replace_html 'todays_time_blocks',
                      :partial => 'todays_time_blocks_show',
                      :locals  => { :tbs => TimeBlock.today.all }
    page.visual_effect :highlight, 'todays_time_blocks'
  end
end
