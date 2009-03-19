module FormSubmissionsHelper
  
  def self.included(base)
    ActionView::Helpers::FormBuilder.send :include, FormBuilderMethods
  end
  
  module FormBuilderMethods
    def form_submission_error_messages
      raise unless @object.is_a?(FormSubmission)
      msg = error_messages
      @object.form.form_fields.each {|field| msg.gsub!(/#{Regexp.escape(field.name).humanize}/, "\"#{field.label}\"")}
      msg
    end
  end
  
  # Developed by Chris Powers, Killswitch Collective on 10/22/2008
  #
  # Formats the value of a FormSubmission's field
  class FormSubmissionFieldDisplay
    
    NO_RESPONSE = "(no response)"
    TRUE_VALUE = "Yes"
    FALSE_VALUE = "No"
    
    def initialize(template, field, value, &block)
      @field = field
      @value = value
      @template = template
      @block = block # need to capture?
    end
    
    def to_s
      label = @field.label
      val = @template.send(:h, formatted_value)
      if @block
        @block.call(label, val)
      else
      <<-EOF
<div class="form_submission_field_display">
  <strong class="label">#{label}</strong>
  <span class="response">#{val}</span>
  <div class="clearer"></div>
</div>
EOF
      end
    end
    
    private
    
    def formatted_value
      if @field.has_many_responses?
        # ensure value is an array
        val = @value || [NO_RESPONSE]
        val = [val] unless val.respond_to?('join')
        val = val.join(", ")
        value_with_blank_notice(val)
      elsif @field.is_a? FormField::CheckBox
        @value == '1' ? TRUE_VALUE : FALSE_VALUE
      else
        value_with_blank_notice(@value)
      end
    end
    
    def value_with_blank_notice(val = nil)
      val.blank? ? NO_RESPONSE : val
    end
  end
  
  def format_submission_field(field, value)
    FormSubmissionFieldDisplay.new(self, field, value)
  end

end
