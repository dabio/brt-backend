document.addEventListener('DOMContentLoaded', function(event) {
    var $ = function(id) {
            return document.getElementById(id) || !1;
        },
        email_el = $('email');

    if (email_el) {
        if (!email_el.innerHTML) return !1;
        var email = email_el.innerHTML.replace(' . ', '.').replace(' [at] ', '@');
        email_el.href = 'mailto:'+email;
        email_el.innerHTML = email;
    }

});



