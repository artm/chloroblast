// This code comes from
// http://stackoverflow.com/questions/499126/jquery-set-cursor-position-in-text-area

(function($) {
  $.fn.caret = function(pos) {
    var target = this[0];
    if (arguments.length == 0) { //get
      if ('selectionStart' in target) { //DOM
        var pos = target.selectionStart;
        return pos > 0 ? pos : 0;
      }
      else if (target.createTextRange) { //IE
        target.focus();
        var range = document.selection.createRange();
        if (range == null)
            return '0';
        var re = target.createTextRange();
        var rc = re.duplicate();
        re.moveToBookmark(range.getBookmark());
        rc.setEndPoint('EndToStart', re);
        return rc.text.length;
      }
      else return 0;
    }

    //set
    var pos_start = pos;
    var pos_end = pos;

    if (arguments.length > 1) {
        pos_end = arguments[1];
    }

    if (target.setSelectionRange) //DOM
      target.setSelectionRange(pos_start, pos_end);
    else if (target.createTextRange) { //IE
      var range = target.createTextRange();
      range.collapse(true);
      range.moveEnd('character', pos_end);
      range.moveStart('character', pos_start);
      range.select();
    }
  }
})(jQuery)
