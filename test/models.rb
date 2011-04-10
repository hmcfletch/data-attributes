class Basic < ActiveRecord::Base
  serialize :data
  data_attribute :stuff
end

class TwoAttribute < ActiveRecord::Base
  serialize :data
  data_attribute :stuff
  data_attribute :things
end

class DifferentSerializedAttribute < ActiveRecord::Base
  serialize :more_data

  data_attribute_column :more_data
  data_attribute :stuff
end

class TwoSerializedAttribute < ActiveRecord::Base
  serialize :data
  serialize :more_data

  data_attribute_column :more_data
  data_attribute :stuff, { :serialized_column => :data, :default => 1 }
  data_attribute :things, { :default => "two" }
end