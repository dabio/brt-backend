//= require ender.min

// replace encoded emails
$('a.email').each(function(el) {
    if (!el.innerHTML) return !1;
    var email = el.innerHTML.replace(' . ', '.').replace(' [at] ', '@');
    el.href = 'mailto:'+email;
    el.innerHTML = email;
});

