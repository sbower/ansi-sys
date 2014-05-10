$:.unshift('lib')
require 'ansisys'

include AnsiSys
# This spec is dependent upon Screen, Cursor, and SGR

def echo(string, col, row)
	@screen = Screen.new
	@char = Characters.new(string, SGR.new)
	@cursor = Cursor.new(col, row, 80, 25)
	@char.echo_on(@screen, @cursor)
end

describe Characters, "when rendered at the right edge" do
  before do
		echo("Test string <HELLO>", 75, 1)
  end

	it "should fold the string at the right edge" do
		@cursor.cur_row.should == 2
		@cursor.cur_col.should == 14
	end
end

describe Characters, "with Japanese characters" do
	before do
		string = "\346\227\245\346\234\254\350\252\236"	# `Nihongo' in UTF-8
		begin
			string.force_encoding('UTF-8')	# ruby 1.9
		rescue NoMethodError
			$KCODE = 'u'	# ruby 1.8
		end
		echo(string, 1, 1)
	end

	it "sohuld assume each occupies 2 columns" do
		@cursor.cur_col.should == 7
	end
end

describe Characters, "with tab" do
	before do
		echo("\t", 1, 1)
	end

	it "sohuld assume it occupies 8 columns" do
		@cursor.cur_col.should == 9
	end
end

