require File.expand_path("helper", File.dirname(__FILE__))

scope do
  test "View contact page" do
    visit "/kontakt"
    # header
    assert has_content?('Berlin Racing Team')

    assert has_content?("E-Mail")
    assert has_content?("Nachricht")
    assert has_content?("Anfrage senden")

    # footer
    assert has_content?('Facebook')
  end

  test "contact error reports" do
    visit "/kontakt"
    # nothing filled
    click_button "Anfrage senden"
    assert has_content?("Bitte gib Deinen Namen an, damit wir Dich ansprechen")
    assert has_content?("daher deine E-Mail.")
    assert has_content?("Du hast Deine Nachricht nicht eingetragen.")

    # fill name
    visit "/kontakt"
    fill_in "contact[name]", with: "Name"
    click_button "Anfrage senden"
    assert has_no_content? "Bitte gib Deinen Namen an, damit wir Dich ansprechen"

    # fill invalid email
    visit "/kontakt"
    fill_in "contact[email]", with: "foo at bar.com"
    click_button "Anfrage senden"
    assert has_content? "Deine E-Mail scheint nicht korrekt zu sein."

    # fill valid email
    visit "/kontakt"
    fill_in "contact[email]", with: "foo@bar.com"
    click_button "Anfrage senden"
    assert has_no_content? "daher deine E-Mail."
    assert has_no_content? "Deine E-Mail scheint nicht korrekt zu sein."

    # fill message
    visit "/kontakt"
    fill_in "contact[message]", with: "testcontent here"
    click_button "Anfrage senden"
    assert has_no_content? "Du hast Deine Nachricht nicht eingetragen."
  end
end



