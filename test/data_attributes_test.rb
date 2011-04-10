require File.expand_path( File.join( File.dirname( __FILE__ ), 'test_helper' ) )

class TestDataAttributes < Test::Unit::TestCase

  def test_setup
    assert_equal Basic.attr_data_attribute_column, :data
    assert_equal Basic.attr_data_attributes, { :stuff => :data }
    assert_equal TwoAttribute.attr_data_attribute_column, :data
    assert_equal TwoAttribute.attr_data_attributes, { :stuff => :data, :things => :data }
    assert_equal DifferentSerializedAttribute.attr_data_attribute_column, :more_data
    assert_equal DifferentSerializedAttribute.attr_data_attributes, { :stuff => :more_data }
    assert_equal TwoSerializedAttribute.attr_data_attribute_column, :more_data
    assert_equal TwoSerializedAttribute.attr_data_attributes, { :stuff => :more_data, :stuff_two => :more_data, :things => :data, :junk => :data, :things_two => :data }
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
    assert_equal t.stuff, nil
    assert_equal t.stuff_two, nil
    assert_equal t.things, nil
    assert_equal t.junk, nil

    t.stuff = "stuff val"
    t.stuff_two = "stuff_two val"
    t.things = "things val"
    t.junk = "junk val"

    assert_equal t.stuff, "stuff val"
    assert_equal t.stuff_two, "stuff_two val"
    assert_equal t.things, "things val"
    assert_equal t.junk, "junk val"
    assert_equal t.data, { "things" => "things val", "junk" => "junk val" }
    assert_equal t.more_data, { "stuff" => "stuff val", "stuff_two" => "stuff_two val" }
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

    assert_equal b.stuff, "blah"
    assert_equal b.data, { "stuff" => "blah" }
  end
end
