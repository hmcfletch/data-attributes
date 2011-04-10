class Basic < ActiveRecord::Base
  serialize :data
  data_attributes :stuff
end

class TwoAttribute < ActiveRecord::Base
  serialize :data
  data_attributes :stuff
  data_attributes :things
end

class DifferentSerializedAttribute < ActiveRecord::Base
  serialize :more_data

  data_attribute_column :more_data
  data_attributes :stuff
end

class TwoSerializedAttribute < ActiveRecord::Base
  serialize :data
  serialize :more_data

  data_attribute_column :more_data
  data_attributes :stuff, { :serialized_column => :data, :default => 1 }
  data_attributes :things, { :default => "two" }
end