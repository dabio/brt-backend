(function() {

  document.addEventListener('DOMContentLoaded', function(event) {
    var $, email, email_el;
    $ = function(id) {
      return document.getElementById(id) || !1;
    };
    email_el = $('email');
    if (email_el) {
      if (!email_el.innerHTML) return !1;
      email = email_el.innerHTML.replace(' . ', '.').replace(' [at] ', '@');
      email_el.href = "mailto:" + email;
      return email_el.innerHTML = email;
    }
  });

}).call(this);
