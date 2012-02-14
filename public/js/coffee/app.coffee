document.addEventListener 'DOMContentLoaded', (event) ->
    $ = (id) ->
        document.getElementById(id) || !1
    email_el = $('email')

    if (email_el)
        return !1 if !email_el.innerHTML
        email = email_el.innerHTML.replace(' . ', '.').replace(' [at] ', '@')
        email_el.href = "mailto:#{email}"
        email_el.innerHTML = email

