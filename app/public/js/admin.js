(function() {
  var root = this,
      $ = root.Zepto || root.jQuery;

  // Allow the deletion of the current object.
  $('form .delete').on('click', function (e) {
    if (confirm('Wirklich löschen?')) {
      $.ajax({
        type: 'DELETE',
        url: e.target.href,
        timeout: 3000,
        success: function(data) {
          console.log(data);
        },
        error: function(xhr, type) {
          alert('Konnte nicht gelöscht werden, bitte erneut versuchen.');
        }
      });
    }

    // prevents to call the url.
    return false;
  });

}).call(this);
