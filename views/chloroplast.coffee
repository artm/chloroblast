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

# AJAX methods and callbacks
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

request_script_list = (autoload_script) ->
  jqx = $.getJSON '/api/script_list', null, receive_script_list
  jqx.error (jqx, status, message) ->
    console.error message
  if autoload_script
    jqx.success ->
      $('#script').val(autoload_script).change()

request_script = (script_name) ->
  $.ajax({
    url: "/scripts/#{script_name}",
    cache: false,
    async: false,
    dataType: 'text',
    success: receive_script
  })

# GUI event handlers
$('#commit').click ->
  text = $("#source").val()
  ($.post '/api',
          { script: text },
          commit_ok,
          'json')
    .error (jqXHR, textStatus, errorThrown) ->
      console.error errorThrown

$('#run').click ->
  source = $('#source').val()
  # now, make a function of that and call it with this=paper
  source = ("  " + line for line in source.split('\n')).join('\n')
  source = "(->\n#{ source }\n).call(paper)"
  try
    js = CoffeeScript.compile source
    eval js
  catch error
    console.error error.message

$('#list').click request_script_list

$('#script').change ->
  name = $('#script').val()
  if (name == "__null__")
    set_source("# chloroblast")
  else
    request_script name

simClick = (button) ->
  $(button).addClass('pressed')
  setTimeout("$('#{button}').removeClass('pressed').click()", 200)

log_keys = false

$("body").keydown (e) ->
  console.log e.which if log_keys
  if e.ctrlKey
    nodef = true
    switch e.which
      when 82
        # Ctrl+R
        simClick '#run'
      when 83
        # Ctrl+S
        simClick '#commit'
      when 72
        # Ctrl+H
        $('#ui').fadeToggle(500)
      when 75
        # Ctrl+K
        log_keys = !log_keys
        console.info "Key logging ", if log_keys then "on" else "off"
      else
        nodef = false
    e.preventDefault() if nodef

tabWidth = 2
oneShiftRe = new RegExp("^ {1,#{tabWidth}}")
String.prototype.repeat = (n) -> (this for i in [1..n]).join("")

# editor enhancements
$('#source').keydown (e) ->
  area = $(@)
  if e.which == 9 && !(e.ctrlKey || e.altKey || e.metaKey)
    # Tab
    e.preventDefault()
    [line,col] = area.caretLineAndCol()
    if area.hasSelection()
      # shift selection
      sel = area.get_selection()
      trail = (/\n$/.exec(sel.text) || [""])[0].length
      if col > 0 || trail > 0
        sel = area.set_selection( sel.start - col, sel.end - trail )
      ins = ' '.repeat(tabWidth)
      lines = (l for l in sel.text.split('\n'))
      text =
        (if e.shiftKey
          ( l.replace(oneShiftRe, '') for l in lines )
        else
          ( ins + l for l in lines )
        ).join('\n')
      area.replace_selection( text )
    else
      # shift current line
      lead = /^\s*/.exec(line)[0]
      if col < lead.length
        delta = lead.length-col
        area.caret( area.caret() + delta )
        col += delta
      if e.shiftKey
        rem_count = lead.length % tabWidth || tabWidth
        area.removeAt( area.caret() - col, rem_count )
      else
        # now we can insert as many spaces as necessary
        ins_count = tabWidth - lead.length % tabWidth
        ins = ' '.repeat(ins_count)
        area.insertAt( area.caret() - col, ins );

$('#clear-log').click ->
  $('#log').children().remove()

# logging
wrap_log_fun = (old_fun, new_fun) ->
  (args...) ->
    new_fun args...
    old_fun.call console, args...

stringify = (x) ->
  if typeof x == "string"
    x
  else
    try
      JSON.stringify x, null, 2
    catch error
      String x

log_fun = (level) ->
  ( args... ) ->
    string = args.map( stringify ).join(" ")
    log = $('#log')
    p = log.parent()
    log.append("<p class='#{level}'>#{string}</p>")
    lines = log.children()
    lines.slice(0,-100).remove() if (lines.size() > 150)
    p.scrollTop( log.height() - p.height() )

$('#log-container').mousewheel (e,d,dx,dy) ->
  #console.log e,d,dx,dy
  delta = dy*$('#log').css('font-size').replace('px','')*1.5
  cont = $('#log-container')
  cont.scrollTop( cont.scrollTop() - delta )

console.log = wrap_log_fun console.log, log_fun "log"
console.debug = wrap_log_fun console.debug, log_fun "debug"
console.info = wrap_log_fun console.info, log_fun "info"
console.warn = wrap_log_fun console.warn, log_fun "warn"
console.error = wrap_log_fun console.error, log_fun "error"

# startup sequence
# keep the editor as large as possible
$(window).resize ->
  h = $("#buttons").position().top - 1
  $("#text-ui")
    .children()
    .height( h )
$(window).resize()

# prepare paper
paper.install(window)
paper.setup('canvas')

request_script_list('chloroblast')
