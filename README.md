Chloroplast
===========

A [live coding][lc] environment using [CoffeeScript][cs] and
[paper.js][paper].

[lc]: http://en.wikipedia.org/wiki/Live_coding
[cs]: http://coffeescript.org/
[paper]: http://paperjs.org/

TODO
====

## save

commit the script on the server each time it's (successfully?) reevaluated

## script names

- give scripts adhoc names:
  - if the first line is a comment, use it as a script name
  - otherwise just call it chloroplast
  - append a unique version number each time the script is committed

## script selector

- script selector
  - two selectors: name and version
  - by default load the latest version
  - version selector also shows a timestamp

