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
    return if time_value.blank?
    time_value.strftime("%H:%M").gsub(/^0/, '')
  end

  def show_field(label, contents)
    '%s <strong>%s</strong><br />' % [label, contents]
  end

  def clearer(contents = nil)
    content_tag(:div, contents, :class => 'clear')
  end

  def time_summary(label, pair)
    period, value = *pair
    label = period.to_s if period.kind_of?(PayPeriod)
    value = elapsed(value) if value.kind_of?(Numeric)
    contents = '<span class="label">%s: <span class="value">%s</span>' % [label, value]
    content_tag(:div, contents, :class => 'time_summary')
  end

  def logged_in_as
    [current_user.display_name, current_user.login].reject(&:blank?).first
  end

  def bracket_link(link, *classes)
    classes = (%w[bracket_link] + classes).join(' ')
    %Q{<span class="#{ classes }">[%s]</span>} % link
  end

  def elapsed(time)
    s = ('%.2f' % time).gsub(/0+$/, '').gsub(/\.$/, '')
    s = 'zero' if s == '0'
    s
  end

end
