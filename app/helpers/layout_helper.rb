module LayoutHelper

  def panel(id, html_options = {}, &proc)
    div_class = html_options[:class] || ''
    html_options[:class] = (div_class + ' panel')
    attrs = html_options.map { |k,v| %Q{#{k.to_s.strip}="#{v.to_s.strip}"} }.join(' ')
    concat %Q{<div id="#{id}" #{attrs}>}
    yield
    concat '</div>'
  end

end
