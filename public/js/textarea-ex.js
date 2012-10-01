// This won't work in IE and probably not in windows at all
(function($) {
  $.fn.hasSelection = function() {
    var e = this.get(0);
    return e.selectionStart != e.selectionEnd;
  }

  // find out caret line
  $.fn.caretLineAndCol = function() {
    var e = this.get(0);
    var pos = e.selectionStart;
    var text = e.value;
    var lineStart = text.lastIndexOf('\n', pos - 1) + 1;
    var lineEnd = text.indexOf('\n', pos);
    var line = lineEnd >= lineStart ? text.slice(lineStart, lineEnd) : text.slice(lineStart);
    return [line, pos-lineStart];
  }

  $.fn.insertAt = function(pos, text) {
    var e = this.get(0);
    var ss = e.selectionStart, se = e.selectionEnd;
    e.value = e.value.substring(0, pos) + text + e.value.substr(pos);

    e.selectionStart = ss < pos ? ss : ss + text.length;
    e.selectionEnd = se < pos ? se : se + text.length;
  }

  $.fn.removeAt = function( pos, amount ) {
    var e = this.get(0);
    var ss = e.selectionStart, se = e.selectionEnd;
    e.value = e.value.substring(0, pos) + e.value.substr(pos + amount);

    e.selectionStart = ss < pos ? ss : ss < (pos + amount) ? pos : (ss-amount);
    e.selectionEnd = se < pos ? se : se < (pos + amount) ? pos : (se-amount);
  }
}(jQuery));

