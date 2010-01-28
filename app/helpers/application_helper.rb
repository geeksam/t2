# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  Dash = '&ndash;'


  def yesno(value)
    value ? 'Yes' : 'No'
  end

  def dash_if_blank(value)
    value.blank? ? Dash : value
  end

  def short_time(time_value)
    return Dash if time_value.blank?
    time_value.strftime("%I:%M %p").gsub(/^0/, '')
  end

  def show_field(label, contents)
    '%s <strong>%s</strong><br />' % [label, contents]
  end

  def clearer(contents = nil)
    content_tag(:div, contents, :class => 'clear')
  end

  def time_summary(label, value)
    if value.kind_of?(Fixnum)
      value = '%.2f' % value
    end
    contents = '<span class="label">%s: <span class="value">%s</span>' % [label, value]
    content_tag(:div, contents, :class => 'time_summary')
  end

  def logged_in_as
    [current_user.display_name, current_user.login].reject(&:blank?).first
  end

end
