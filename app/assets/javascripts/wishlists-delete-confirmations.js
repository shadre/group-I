$("[data-toggle=popover-with-html]").popover({
  html: true,
  content: function() {
    return $($(this).data('content-source')).html();
  }
});
