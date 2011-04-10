require 'test/unit'
require 'active_record'

require File.expand_path( File.join( File.dirname( __FILE__ ), '..', 'lib', 'data-attributes' ) )

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

require File.expand_path( File.join( File.dirname( __FILE__ ), 'schema' ) )
require File.expand_path( File.join( File.dirname( __FILE__ ), 'models' ) )
