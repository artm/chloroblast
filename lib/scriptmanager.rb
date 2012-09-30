class ScriptManager
  def initialize(path)
    @path = path
  end

  def scripts
    Set.new(Dir.glob( path("*") ).
            map{|x| %r{([^/]+?)\.coffee$}.match(x) && $1}.
            select{|x| x})

  end

  def parse_name(script)
    if /\s*# *(.*?) *$/.match(script)
      $1.gsub(' ','-')
    else
      "chloroblast"
    end
  end

  def save(script)
    name = parse_name(script)
    fname = path(name)
    File.open(fname,'w') do |f|
      f.puts script
    end
    name
  end

  def path name
    "#{@path}/#{name}.coffee"
  end
end

