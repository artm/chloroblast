require 'scriptmanager'

describe ScriptManager do
  before do
    Dir.stub(:glob) { ["foo/a.coffee", "foo/b.coffee", "foo/c.coffee", "foo/README.md"] }
    @sm = ScriptManager.new "foo"
  end
  it 'collects coffee scripts' do
    "abc".each_char {|x| @sm.scripts.should include(x)}
    @sm.scripts.each {|x| "abc".should include(x)}
  end

  it 'parses script name' do
    name = @sm.parse_name "# script \nfoo ->\n  bar"
    name.should == "script"
  end

  it 'comes up with a default name' do
    name = @sm.parse_name "foo =>\n  bar"
    name.should == "chloroblast"
  end

  it 'converts spaces to dashes' do
    name = @sm.parse_name "# script name \nfoo ->\n  bar"
    name.should == "script-name"
  end

  it 'saving a script adds it to the scripts' do
    File.stub(:open)
    name = @sm.save "# script \nfoo ->\n  bar"
    name.should == "script"
  end
end
