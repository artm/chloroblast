paper.install(window)
paper.setup('canvas')

$("#source").attr("value","# chloroplast \n
r = Math.random \n
@project.activeLayer.removeChildren() \n
p = new Path.Circle(new Point(500*r(),200*r()), 10+90*r()) \n
@view.onFrame = (e) -> \n
  p.fillColor = new RgbColor( r(), r(), r())")

$('#run').click ->
  source = $('#source').attr("value")
  # now, make a function of that and call it with this=paper
  source = ("  " + line for line in source.split('\n')).join('\n')
  source = "(->\n#{ source }\n).call(paper)"
  try
    js = CoffeeScript.compile source
    eval js
  catch error
    console.log "ERROR: " + error.message

$('#new').click ->
  $("#source").attr("value", "# chloroplast")

$(window).resize ->
  $("#source").height( $("#buttons").position().top - 1 )

$(document).ready ->
  $(window).resize()
