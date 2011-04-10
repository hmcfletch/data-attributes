require File.expand_path( File.join( File.dirname( __FILE__ ), 'test_helper' ) )

class TestDataAttributes < Test::Unit::TestCase

  def test_setup
    assert_equal Basic.attr_data_attribute_column, :data
    assert_equal Basic.attr_data_attributes, { :stuff => { :serialized_column => :data, :default => nil } }
    assert_equal TwoAttribute.attr_data_attribute_column, :data
    assert_equal TwoAttribute.attr_data_attributes, {
      :stuff  => { :serialized_column => :data, :default => nil },
      :things => { :serialized_column => :data, :default => nil }
    }
    assert_equal DifferentSerializedAttribute.attr_data_attribute_column, :more_data
    assert_equal DifferentSerializedAttribute.attr_data_attributes, { :stuff => { :serialized_column => :more_data, :default => nil } }
    assert_equal TwoSerializedAttribute.attr_data_attribute_column, :more_data
    assert_equal TwoSerializedAttribute.attr_data_attributes, {
      :stuff => { :serialized_column => :data, :default => 1 },
      :things => { :serialized_column => :more_data, :default => "two" }
    }
  end

  def test_basic
    b = Basic.new
    assert_equal b.data, nil
    assert_equal b.stuff, nil

    b.stuff = "blah"
    assert_equal b.stuff, "blah"
    assert_equal b.data, { "stuff" => "blah" }
  end

  def test_primitives_methods
    b = Basic.new
    assert_equal b.data, nil
    assert_equal b.read_data_attribute("stuff"), nil

    b.write_data_attribute("stuff", "blah")
    assert_equal b.data, { "stuff" => "blah" }
    assert_equal b.read_data_attribute("stuff"), "blah"
  end

  def test_two_attributes
    b = TwoAttribute.new
    assert_equal b.data, nil
    assert_equal b.stuff, nil

    b.stuff = "blah"
    assert_equal b.stuff, "blah"
    assert_equal b.data, { "stuff" => "blah" }

    b.things = "boom"
    assert_equal b.stuff, "blah"
    assert_equal b.things, "boom"
    assert_equal b.data, { "stuff" => "blah", "things" => "boom" }
  end

  def test_primitives_methods_two
    b = TwoAttribute.new
    assert_equal b.data, nil
    assert_equal b.read_data_attribute("stuff"), nil

    b.write_data_attribute("stuff", "blah")
    assert_equal b.read_data_attribute("stuff"), "blah"
    assert_equal b.data, { "stuff" => "blah" }

    b.write_data_attribute("things", "boom")
    assert_equal b.read_data_attribute("stuff"), "blah"
    assert_equal b.read_data_attribute("things"), "boom"
    assert_equal b.data, { "stuff" => "blah", "things" => "boom" }
  end

  def test_two_serialized
    t = TwoSerializedAttribute.new
    assert_equal t.data, nil
    assert_equal t.more_data, nil
    assert_equal t.stuff, 1
    assert_equal t.things, "two"

    t.stuff = "stuff val"
    t.things = "things val"

    assert_equal t.stuff, "stuff val"
    assert_equal t.things, "things val"
    assert_equal t.more_data, { "things" => "things val" }
    assert_equal t.data, { "stuff" => "stuff val" }
  end

  def test_saving
    b = Basic.create
    id = b.id
    assert_equal b.data, nil
    assert_equal b.stuff, nil

    b.stuff = "blah"
    assert_equal b.stuff, "blah"
    assert_equal b.data, { "stuff" => "blah" }

    b.save

    b = Basic.find(id)
    assert_equal b.stuff, "blah"
    assert_equal b.data, { "stuff" => "blah" }
  end

  def test_non_serialized_error
    klass = Class.new(ActiveRecord::Base)
    ActiveRecord::Base.const_set("NonSerializedAttribute", klass)

    assert_raise(DataAttributes::NonSerializedColumnError) do
      klass.class_eval do
        data_attributes :stuff
      end
    end
  end

  def test_data_attribute_options
    assert_raise(DataAttributes::NonDataAttributeError) do
      Basic.data_attribute_options(:things)
    end
  end
end
