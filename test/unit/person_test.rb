require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  test "for validation" do
    # Person needs at least a first, last name and email address.
    person = Person.new({first_name: 'FirstName'})
    assert !person.valid?

    person.last_name = 'LastName'
    assert !person.valid?

    person.email = 'firstname@lastname.com'
    assert !person.valid?
  end

  test "for valid email address" do
    person = Person.new({first_name: 'FirstName', last_name: 'LastName',
      password: 'test1234'})
    assert !person.valid?
    # invalid address - missing name
    person.email = 'blah.com'
    assert !person.valid?
    # invalid address - missing domain
    person.email = 'test@.com'
    assert !person.valid?
    # invalid address - missing tld
    person.email = 'test@test'
    assert !person.valid?
    # valid address
    person.email = 'test@test.com'
    assert person.valid?
  end

  test "for password confirmation" do
    person = Person.new({first_name: 'FirstName', last_name: 'LastName',
      email: 'test@test.com'})
    assert !person.valid?
    # wrong confirmation password
    person.password, person.password_confirmation = 'blah', 'blah1234'
    assert !person.valid?
    # correct confirmation password
    person.password, person.password_confirmation = 'blah1234', 'blah1234'
    assert person.valid?
    assert person.save
  end

  test "for valid name" do
    person = Person.new({first_name: 'FirstName', last_name: 'LastName'})

    assert person.name == 'FirstName LastName'
    assert person.name != 'LastName FirstName'
    assert person.name != 'WrongName LastName'

    person.first_name = 'CorrectName'
    assert person.name == 'CorrectName LastName'
  end
end
