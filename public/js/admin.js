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
          window.location = data;
        },
        error: function(xhr, type) {
          alert('Konnte nicht gelöscht werden, bitte erneut versuchen.');
        }
      });
    }

    // prevents to call the url.
    return false;
  });


  var addParticipation = function (el) {

      $.ajax({
        type: 'POST',
        url: el.data('url'),
        data: { person_id: el.data('person'), event_id: el.data('event') },
        timeout: 3000,
        dataType: 'json',
        success: function(data) {
          el.removeAttr('data-person').removeAttr('data-event')
            .attr({ 'data-id': data.id, 'data-url': data.deletelink });

          $('#event_' + data.event.id + ' .participations')
            .append('<span data-id="'+data.id+'">'+data.person.name+'</span>');
        },
        error: function(xhr, type) {
          console.log(xhr);
        }
      });
    },

    removeParticipation = function (el) {

      $.ajax({
        type: 'DELETE',
        url: el.data('url'),
        timeout: 3000,
        dataType: 'json',
        success: function(data) {
          $('span[data-id="' + el.data('id') + '"]').remove();
          el.attr({
            'data-event': data.event.id,
            'data-person': data.person.id,
            'data-url': data.url
          });
          el.removeAttr('data-id');
        },
        error: function(xhr, type) {
          console.log(xhr);
        }
      });

    };


  // Dashboard, remove person from participationlist
  $('#dashboard input[type=checkbox]').on('click', function (e) {
    var el = $(e.target);
    el.attr('checked') ? addParticipation(el) : removeParticipation(el);
  });

}).call(this);