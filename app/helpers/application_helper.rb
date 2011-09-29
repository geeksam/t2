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
    label = period.to_s    if period.kind_of?(TimePeriod)
    value = elapsed(value) if value.kind_of?(Numeric)
    return if Float(value).zero?
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
    # s = '--' if s == '0'
    s
  end

  def active_task_options(options = {})
    collection = Project.with_active_tasks.all(:include => [:tasks] )
    truncated_to = options[:truncated_to]
    option_value_method = truncated_to.blank? ? :name : :"name_truncated_to_#{truncated_to}"
    selected_key = options[:selected] || Task.find_current.try(:id)

    option_groups_from_collection_for_select(
      collection,
      :active_tasks, :name,
      :id, option_value_method,
      selected_key
    )
  end


  # Leaving those '|' characters dangling at the end of a line was getting
  # annoying.  This encapsulates the micropattern of putting several text
  # items (links or otherwise) together, with an arbitrary separator between them.
  def separated_group(separator = ' | ', &proc)
    SeparatedGroupBuilder.new(separator, &proc).to_s
  end
  class SeparatedGroupBuilder
    def initialize(separator = ' | ', &proc)
      @separator = separator
      @items = []
      yield self
    end

    def <<(item)
      @items << item
    end

    def to_s
      @items.join(@separator)
    end
  end

end
