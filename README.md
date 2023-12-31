# ABOUT

This application is meant for St Charles Automotive. It provides a set of endpoints that allow taking service
reservations over the phone in a single step, as well endpoints for updating the customer, vehicle, and reservation
information. Reservations are not allowed to overlap (this requirement was implied by customers needing to **secure** a
time slot).

I considered preventing reservations for dates that have already passed, but quite often information can be entered into
a computer after the fact and back dated, so I'm being cautiously optimistic about that not being a requirement.

**This application is meant to be run in a secure environment, such as on a VPN, as no security has been implemented.**

# USAGE

The endpoints use REST. Example usage can be seen in the controller tests:
* test\controllers\api\v1\customers_controller_test.rb
* test\controllers\api\v1\reservations_controller_test.rb
* controllers\api\v1\scheduling_controller_test.rb
* controllers\api\v1\vehicles_controller_test.rb

The main use case, taking service reservations over the phone in a single step, can be seen in
controllers\api\v1\scheduling_controller_test.rb.

# REQUIREMENTS

This application requires a Ruby (version 3.2.2), Ruby Gems (version 3.4.20), and a PostgreSQL database (version 14.5).

# SETUP

To setup the application:
1. Set a username and password for each environment in config/database.yml. Additional changes in config/database.yml
may be needed if you changed any PostgreSQL configuration defaults, such as the port.
2. Run `bundle install`.
3. Run `rake db:setup`.
4. Run `rake db:migrate`.

# DEPLOYMENT

To launch the application, run `rails s`. It will listen at http://127.0.0.1:3000.

# TESTING

Run `rails test` to run the unit and integration tests for this application. Tests are stored in the test directory. For
example, test/controllers/api/v1/scheduling_controller_test.rb. **There are both model and controller tests.**