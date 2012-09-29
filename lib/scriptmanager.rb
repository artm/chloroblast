class ScriptManager
  attr_reader :scripts
  def initialize(path)
    @scripts = Set.new(Dir.glob("#{path}/*.coffee").
                       map{|x| /(.+?)\.coffee$/.match(x) && $1}.
                       select{|x| x})
    @path = path
  end

  def parse_name(script)
    if /\s*# *(.*?) *$/.match(script)
      $1.gsub(' ','-')
    else
      "chloroblast"
    end
  end

  def script_names
    @scripts.map {|x| x.sub(/\.coffee/,'')}
  end

  def save(script)
    name = parse_name(script)
    fname = "#{@path}/#{name}.coffee"
    File.open(fname,'w') do |f|
      f.puts script
    end
    @scripts << name
    name
  end
end

