module CheckBoxGroupHelper
  
  def self.included(base)
    ActionView::Helpers::FormBuilder.send :include, InstanceMethods
  end
  
  module InstanceMethods
    # used for the dynamic forms for string values in an array
    def check_box_group(name, full_collection, options={}, &block)
      options[:source] ||= name
      obj_collection = case options[:source]
        when Symbol: @object.send(options[:source])
        when Array: options[:source]
        else []
      end
      obj_collection ||= []
      boxes = full_collection.collect do |item|
        n = name_for(name, '')
        id = id_for(name)
        checked = obj_collection.include? item
        markup = %Q{<input type="checkbox" id="#{id}" name="#{n}" value="#{item}" #{'checked' if checked} />}
        [markup, item]
      end
      if block_given?
        boxes.each do |markup, item|
          yield markup, item
        end
      else
        out = []
        out << "<ul class='check_box_group'>\n"
        boxes.each do |markup, item|
          out << "<li>#{markup}<label for='#{name_for name}'>#{item}</label></li>\n"
        end
        out << "</ul>\n<div class='clearer'></div>\n"
        out
      end
    end
    
    private
    
    def name_for(_name, _id=nil)
      n = "#{@object_name}[#{_name}]"
      n += "[#{_id}]" if _id
      n
    end

    def id_for(_name, _id=nil)
      n = "#{@object_name}_#{_name}"
      n += "_#{_id}" if _id
      n
    end
    
  end
  
end