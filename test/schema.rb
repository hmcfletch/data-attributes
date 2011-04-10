ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  
  ActiveRecord::Schema.define do
    create_table "basics" do |t|
      t.text :data
    end

    create_table "two_attributes" do |t|
      t.text :data
    end

    create_table "different_serialized_attribute" do |t|
      t.text :more_data
    end

    create_table "two_serialized_attributes" do |t|
      t.text :data
      t.text :more_data
    end

    create_table "non_serialized_attributes" do |t|
      t.text :data
    end

    create_table "default_non_serialized_attributes" do |t|
      t.text :more_data
    end
  end
end
