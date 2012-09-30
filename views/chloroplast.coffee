# keep the editor as large as possible
$(window).resize ->
  $("#source").height( $("#buttons").position().top - 1 )
$(window).resize()

# prepare paper
paper.install(window)
paper.setup('canvas')

select_script = (name, insert) ->
  opt = $("#script option[value='#{ name }']")
  if opt.length > 0
    opt.get(0).selected = true
  else if insert
    # insert just before the __null__
    $('#script option:last').before( $(new Option(name, name, true, true)) )
  else
    $('#script').val("__null__")

set_source = (text) ->
  $("#source").val( text )
  m = /^((\s*#\s*).*)(\n|$)/.exec(text)
  if m
    $("#source").set_selection( m[2].length, m[1].length )

# AJAX callbacks
commit_ok = (data) ->
  select_script data.name, true

receive_script_list = (data) ->
  # remember what was selected
  sel = $('#script')
  last_selection = sel.val()
  # repopulate the selector
  elt = sel.get(0)
  while elt.options && elt.options.length
    elt.remove(0)
  elt.add( new Option(name,name) ) for name in data.script_list
  elt.add( new Option("", "__null__") )
  # select last selected option if present
  select_script last_selection, false

receive_script = (data) ->
  set_source( data )

request_script_list = ->
  jqx = $.getJSON '/api/script_list', null, receive_script_list
  jqx.error (jqx, status, message) ->
    console.log "ERROR: #{message}"

# GUI event handlers
$('#commit').click ->
  text = $("#source").val()
  ($.post '/api',
          { script: text },
          commit_ok,
          'json')
    .error (jqXHR, textStatus, errorThrown) ->
      console.log "ERROR: #{errorThrown}"

$('#run').click ->
  source = $('#source').val()
  # now, make a function of that and call it with this=paper
  source = ("  " + line for line in source.split('\n')).join('\n')
  source = "(->\n#{ source }\n).call(paper)"
  try
    js = CoffeeScript.compile source
    eval js
  catch error
    console.log "ERROR: #{error.message}"

$('#list').click request_script_list

$('#script').change ->
  name = $('#script').val()
  if (name == "__null__")
    set_source("# chloroblast")
  else
    $.ajax({
      url: "/scripts/#{name}",
      cache: false,
      async: false,
      dataType: 'text',
      success: receive_script
    })

request_script_list()
$('#script').change()
