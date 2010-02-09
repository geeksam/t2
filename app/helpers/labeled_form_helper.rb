module LabeledFormHelper

  def labeled_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    form_for(record_or_name_or_array, *(args << options.merge(:builder => LabeledFormBuilder)), &proc)
  end

  class LabeledFormBuilder < ActionView::Helpers::FormBuilder
    helpers = field_helpers +
              %w{date_select datetime_select time_select} +
              %w{collection_select select country_select time_zone_select} -
              %w{hidden_field label fields_for} # Don't decorate these

    helpers.each do |name|
      define_method(name) do |field, *args|
        options = args.last.is_a?(Hash) ? args.pop : {}
        label = label(field, options[:label], :class => options[:label_clas])
        @template.content_tag(:div, label + super)
        # 
        # @template.content_tag(:p, label +'<br/>' + super)  #wrap with a paragraph
      end
    end
  end

end
