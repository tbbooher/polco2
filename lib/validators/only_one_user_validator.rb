#class OnlyOneUserValidator < ActiveModel::EachValidator
#  def validate_each(record, attribute, value)
#    puts "validation called with value: |#{value}| for attribute |#{attribute}|"
#    value_array = (value.is_a?(Array) ? value : [value])  # ensure we have an array
#    if record.send(attribute).is_a?(Array) && (record.send(attribute) & value_array).any?
#      record.errors[attribute] << (options[:message] || "A user can only join a group once")
#      puts "validation failed !!!!!!!!!!!!"
#      puts "attribute values: #{record.send(attribute)}"
#      puts "value: #{value}"
#      puts record.send(attribute).size
#    else
#      puts "validation passed !!!!!!!!!!!!"
#      puts "attribute: #{attribute}"
#      puts "value: #{value}"
#      puts record.send(attribute)
#      puts "no problem"
#    end
#  end
#end
