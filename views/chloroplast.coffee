$(document).ready ->
  paper.install(window)
  $("#script").attr("value","
p = new Path.Circle(new Point(500,200), 50)    \n
@view.onFrame = (e) ->                         \n
  p.fillColor = new RgbColor( Math.random(),   \n
                              Math.random(),   \n
                              Math.random())   \n
    ")


$('#run').click ->
  script = $('#script').attr("value")
  # now, make a function of that and call it with this=paper
  script = ("  " + line for line in script.split('\n')).join('\n')
  script = "(->\n#{ script }\n).call(paper)"
  try
    js = CoffeeScript.compile script
    eval js
  catch error
    console.log "ERROR: " + error.message
