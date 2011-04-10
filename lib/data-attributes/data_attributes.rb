module DataAttributes
  module DataAttributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      DEFAULT_DATA_COLUMN = :data

      # set the default serialized attribute to use to store all the values
      # default is :data
      # raises +NonSerializedColumnError+ if value isn't serlialized
      def data_attribute_column(value)
        raise(NonSerializedColumnError) unless serialized_attributes[value.to_s]
        write_inheritable_attribute(:attr_data_attribute_column, value.to_sym)
      end

      # set up an attribute accessor for values stored in the serialized hash
      # takes an attribute name and a hash sets up a read and write accessor for it
      # options:
      #   :serialized_column => the column used to store the attribute info
      #   :default => what to return if the attribute is not set
      # raises +NonSerializedColumnError+ if the column specified isn't serlialized
      def data_attribute(name, arg_opts={})
        opts = {
          :serialized_column => attr_data_attribute_column,
          :default => nil
        }

        opts.merge!(arg_opts)

        # make sure the serialized_column is actually serialized 
        raise(NonSerializedColumnError) unless serialized_attributes[opts[:serialized_column].to_s]

        attr_data_attributes[name.to_sym] = opts

        attr_name = name.to_s
        class_eval("def #{attr_name}; read_data_attribute('#{attr_name}'); end")
        class_eval("def #{attr_name}= (value); write_data_attribute('#{attr_name}', value); end")
      end

      def attr_data_attributes
        read_inheritable_attribute(:attr_data_attributes) or write_inheritable_attribute(:attr_data_attributes, {})
      end

      def attr_data_attribute_column
        read_inheritable_attribute(:attr_data_attribute_column) or write_inheritable_attribute(:attr_data_attribute_column, DEFAULT_DATA_COLUMN)
      end

      def data_attribute_options(name)
        attr_data_attributes.has_key?(name.to_sym) ? attr_data_attributes[name.to_sym] : raise(NonDataAttributeError)
      end

      def data_attribute_serialized_column(name)
        data_attribute_options(name)[:serialized_column]
      end

      def data_attribute_default(name)
        data_attribute_options(name)[:default]
      end
    end

    def read_data_attribute(name)
      (self.send(data_attribute_serialized_column(name)) || {}).has_key?(name) ? self.send(data_attribute_serialized_column(name))[name] : self.data_attribute_default(name)
    end

    def write_data_attribute(name, value)
      if self.send(data_attribute_serialized_column(name)).nil?
        self.send("#{data_attribute_serialized_column(name)}=", { name => value })
      else
        self.send("#{data_attribute_serialized_column(name)}=", self.send(data_attribute_serialized_column(name)).merge({ name => value }))
      end
    end

    def data_attribute_serialized_column(name); self.class.data_attribute_serialized_column(name) end
    def data_attribute_default(name); self.class.data_attribute_default(name) end
  end
end

ActiveRecord::Base.send(:include, DataAttributes::DataAttributes)