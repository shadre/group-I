$(".wlist [data-toggle=popover]").popover({
  html: true,
  content: function() {
    return $($(this).data('content-source')).html();
  }
});
