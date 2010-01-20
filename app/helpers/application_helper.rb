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

end
