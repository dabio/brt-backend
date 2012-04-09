prepare_emails = ->
    email_el = $('#email')
    email = email_el.text().replace(' . ', '.').replace(' [at] ', '@')
    email_el.attr('href', "mailto:#{email}")
    email_el.text(email)

add_current_person = (resp) ->
    count = $("##{resp.id} ul.participants li").length
    if count == 0
        tmpl = $('#participants-li-first').html()
    else
        tmpl = $('#participants-li-more').html()
    $("##{resp.id} ul.participants li").first().prepend(tmpl)

remove_current_person = (resp) ->
    $("##{resp.id} ul.participants li.me").remove()

$.domReady( ->
    prepare_emails()

    $('input.participation').click( ->
        checked = this.checked
        $.ajax({
            url: this.value
            method: if checked then 'post' else 'delete'
            type: 'json'
            contentType: 'json'
            success: (resp) ->
                if checked
                    add_current_person(resp)
                else
                    remove_current_person(resp)

        })
    )

)

#$ = (id) ->
#    document.getElementById(id) || !1
#
#document.addEventListener 'DOMContentLoaded', (event) ->
#    email_el = $('email')
#
#   if (email_el)
#        return !1 if !email_el.innerHTML
#        email = email_el.innerHTML.replace(' . ', '.').replace(' [at] ', '@')
#        email_el.href = "mailto:#{email}"
#        email_el.innerHTML = email
#
