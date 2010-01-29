module ExpandableHelper

  def expandable(id, options = {}, &proc)
    options.reverse_merge!({:header => 'value'})
    builder = ExpandableDivBuilder.new(id, output_buffer, options)
    
    concat builder.before_html
    yield builder
    concat builder.after_html
  end

  class ExpandableDivBuilder
    include ActionView::Helpers
    attr_accessor :id, :collapsed, :float_link
    attr_accessor :more_text, :less_text
    attr_reader :output_buffer

    def initialize(id, output_buffer, options = {})
      @id            = id
      @collapsed     = options.has_key?(:collapsed) ? options[:collapsed ] : true
      @float_link    = options[:float_link]
      @output_buffer = output_buffer
    end

    def header(&proc)
      
    end

    def less(&proc)
      concat %Q{<div id="#{id}_less" style="#{'display: none;' if !collapsed}" content_option="less">}
      yield
      concat '</div>'
    end

    def more(&proc)
      concat %Q{<div id="#{id}_more" style="#{'display: none;' if  collapsed}" content_option="more">}
      yield
      concat '</div>'
    end

    def before_html
      less_link = link_to_function('less', "expandable_show_less('#{id}');", :id => "#{id}_less_link", :style => ('display: none;' if  collapsed))
      more_link = link_to_function('more', "expandable_show_more('#{id}');", :id => "#{id}_more_link", :style => ('display: none;' if !collapsed))
      both_links = %Q{[#{more_link}#{less_link}]}
      returning '' do |s|
        s << both_links if float_link.blank?
        s << %Q{<div id="#{id}">}
        s << %Q{<div style="float: #{float_link};">#{both_links}</div>} if float_link.present?
      end
    end

    def after_html
      '</div>'
    end
  end

end
