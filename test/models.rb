# class Template < ActiveRecord::Base
#   serialize :data
# 
#   data_attribute_column :things
#   data_attributes :stuff, { :junk => :data, :blarg => :data, :foo => :things }, { :huh => :data }
# 
# end

class Basic < ActiveRecord::Base
  serialize :data
  data_attributes :stuff
end

class TwoAttribute < ActiveRecord::Base
  serialize :data
  data_attributes :stuff, :things
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
  data_attributes :stuff, 'stuff_two', { :things => :data, :junk => :data }, { :things_two => :data }
end