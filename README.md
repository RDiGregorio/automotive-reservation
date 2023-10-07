# ABOUT

This application is meant for St Charles Automotive. It provides a set of endpoints that allow taking service
reservations over the phone in a single step, as well endpoints for updating the customer, vehicle, and reservation
information.

Overbooking isn't a problem. Customers can drop of their cars at any time and the mechanics will complete the job as
soon as possible. Sometimes that means a customer's car is waiting for a while before being worked on, but that is
normal practice in the industry.

Reservations are allowed to be added in the past because it is sometimes the case where the internet is down and a
reservation is needed to be entered when it comes back online. In such a case, a reservation may be back dated.

**It is meant to be run in a secure environment, such as on a VPN, as no security has been implemented.**

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
1. Set a username and password for each environment in config/database.yml.
2. Run `bundle install`.
3. Run `rake db:setup`.
4. Run `rake db:migrate`.

# DEPLOYMENT

To launch the application, run `rails s`. It will listen at http://127.0.0.1:3000.

# TESTING

Run `rails test` to run the unit and integration tests for this application. Tests are stored in the test directory. For
example, test/controllers/api/v1/scheduling_controller_test.rb. There are both model and controller tests.