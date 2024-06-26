@mod @mod_data @datafield @datafield_regex
Feature: Users can use the datatype field regex and add an entry with that type.

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | 0 |
    And the following "course enrolments" exist:
      | user | course | role |
      | student1 | C1 | student |
    And the following "activities" exist:
      | activity | name               | intro | course | idnumber |
      | data     | Test database name | n     | C1     | data1    |

  @javascript
  Scenario: Student can add an entry to a database with a valid value for a regex field.
    Given the following "mod_data > fields" exist:
      | database | type  | name        | description  | param3     | required |
      | data1    | text  | field text  | Some text    |            | 0        |
      | data1    | regex | field regex | Descr. regex | foss(bar)? | 1        |
    When I am on the "Course 1" course page logged in as student1
    And I am on the "Test database name" "mod_data > add entry" page logged in as student1
    And I set the following fields to these values:
      | field text  | some value |
      | field regex |            |
    And I press "Save"
    Then I should see "You must supply a value here."
    When I set the field "field regex" to "someval"
    And I press "Save"
    Then I should see "Your input didn't match the expected pattern."
    And I set the field "field regex" to "fossbar"
    And I press "Save"
    Then I should see "field regex"
    And I should see "Last edited:"
    And I should not see "Your input didn't match the expected pattern."

  @javascript
  Scenario: Student receives an custom error message when invalid input is provided.
    Given the following "mod_data > fields" exist:
      | database | type  | name        | description  | param3     | required | param5                                                                                                               |
      | data1    | text  | field text  | Some text    |            | 0        |                                                                                                                      |
      | data1    | regex | field regex | Descr. regex | foss(bar)? | 1        | <span class="multilang" lang="en">Data error in EN</span><span class="multilang" lang="de">Datenfehler auf DE</span> |
    When I am on the "Course 1" course page logged in as student1
    And I am on the "Test database name" "mod_data > add entry" page logged in as student1
    And I set the following fields to these values:
      | field text  | some value |
      | field regex | invalid    |
    And I press "Save"
    Then I should see "Data error in EN"
    And I should not see "Your input didn't match the expected pattern."
    When I set the field "field regex" to "fossbar"
    And I press "Save"
    Then I should see "field regex"
    And I should see "Last edited:"
    And I should not see "Data error in EN"
    And I should not see "Your input didn't match the expected pattern."
