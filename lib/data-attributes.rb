module DataAttributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    DEFAULT_DATA_COLUMN = :data

    # set the default serialized attribute to use to store all the values
    # default is :data
    def data_attribute_column(value)
      write_inheritable_attribute(:attr_data_attribute_column, value.to_sym)
    end

    # set up attribute accessors for values stored in the serialized hash
    # takes and array and sets up a read and write accessor for each one
    # use :attr_data_attribute_column unless a hash is given, then the key
    # is the attribute and the value is the serialized attribute to use for storage
    def data_attributes(*args)
      args.each do |arg|
        if arg.is_a?(String) || arg.is_a?(Symbol)
          attr_data_attributes[arg.to_sym] = attr_data_attribute_column
        elsif arg.is_a?(Hash)
          arg.each_pair do |k,v|
            if serialized_attributes[v.to_s]
              attr_data_attributes[k.to_sym] = v.to_sym
            else
              raise "Must use a serialized column, '#{v}' is not serialized."
            end
          end
        end
      end

      attr_data_attributes.each_pair do |k,v|
        attr_name = k.to_s
        class_eval("def #{attr_name}; read_data_attribute('#{attr_name}'); end")
        class_eval("def #{attr_name}= (value); write_data_attribute('#{attr_name}', value); end")
      end
    end

    def attr_data_attributes
      read_inheritable_attribute(:attr_data_attributes) or write_inheritable_attribute(:attr_data_attributes, {})
    end

    def attr_data_attribute_column
      read_inheritable_attribute(:attr_data_attribute_column) or write_inheritable_attribute(:attr_data_attribute_column, DEFAULT_DATA_COLUMN)
    end

    def data_column(name)
      attr_data_attributes[name.to_sym].to_sym
    end
  end

  def read_data_attribute(name)
    (self.send(data_column(name)) || {})[name]
  end

  def write_data_attribute(name, value)
    if self.send(data_column(name)).nil?
      self.send("#{data_column(name)}=", { name => value })
    else
      self.send("#{data_column(name)}=", self.send(data_column(name)).merge({ name => value }))
    end
  end

  def data_column(name)
    self.class.data_column(name)
  end
end

ActiveRecord::Base.send(:include, DataAttributes)