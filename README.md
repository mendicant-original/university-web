![University Web Logo](https://github.com/mendicant-university/university-web/raw/master/doc/university-web.png)

This Ruby on Rails application provides facilities to support a community of
teachers and learners. It currently offers the essentials needed to manage
multiple courses, and we are now also developing other features for enabling
members of the community to work together.

University Web is developed by the
[Mendicant University](http://mendicantuniversity.org), an
online learning community, and it is our core infrastructure.
We expect it to become potentially useful to other organizations, and hope that
it will be adopted elsewhere as it becomes mature.

Whether you are a member of Mendicant University or a developer interested in
systems for learning and education, we encourage you to check out the source
code: <http://github.com/mendicant-university/university-web>

If you are not a member of Mendicant University, please get in touch through our
public channels:

- **IRC:** #mendicant on freenode.net
- **Twitter:** #mendicant

## Key Features

University Web is constantly evolving, but currently offers the following
functionality:

- Administration of course admissions
- Course management
- Assignment tracking
- A clean and user-friendly interface for students
- IRC channel integration
- In application document system

## Installation

University Web is a Ruby on Rails 3 application which runs on Ruby 1.9.2 and on
[PostgreSQL](http://www.postgresql.org) databases. Other databases like MySQL
or SQLite are not officially supported.

**Always use the latest source code:** We are constantly working on this
application, with bug fixes and new features added daily, so please use the
very latest source code.

### Setting Up a Development Copy: Step by Step

To install a development version of University Web, follow these steps:

1. Fork our GitHub repository: <http://github.com/mendicant-university/university-web>
2. Clone the fork to your computer
3. Run `bundle install` to install all of the dependencies

To configure University Web [Basic]:

1. Create a `database.yml` file in `config`. The `config` directory contains
   an example `database.yml` for PostgreSQL.
2. Create a `config/initializers/secret_token.rb` file. The
   `config/initializers` directory contains an example `secret_token.rb` file
   with instructions for generating a secret token.
3. Run the Rails tasks to initialize a development and a test database:

    ```bash
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    ```

4. Finally, run the test suite to make sure everything is working correctly:

    ```bash
    $ bundle exec rake test
    ```

To configure University Web [Full]:

1. Follow the steps in _To configure University Web [Basic]_
2. Create a `config/github.yml` files. The `config` directory contains an
   example `github.yml` file.

## Using University Web

### Users

- University Web user accounts may be either admins, students, or guests.
- Every account is identified by email address.
- The admin users may access all of the management features of University Web by
  choosing **Administration** from the navigation menu at the top of page.
- The management features of University Web enable admin users to perform the
  standard tasks for running courses, such as creating other user accounts for
  students and guests, defining the courses and managing assignment submissions.

### Terms

- Each term is a group of one or more courses.
- To create a new term, login as an admin user, and choose
  **Administration > Terms > Create Term**.

### Courses

- To create a new course, choose **Administration > Courses > Create New Course**.
- Once you have created a course, use the course form to attach a user to it as
  an instructor, along with students and assignments. The next section explains
  assignments.
- You may group courses into terms. Courses don't have to be associated with a
  term.

### Assignments

- Each course may have one or more assignments attached to it.
- To create or manage assignments for a course, choose
  **Administration > Courses**, click on the **Assignments** link next to the
  name of the course, and choose **Create New Assignment**.
- Once an assignment has been created, some or all of the students in the course
  may then be set that assignment.
- The students may use the University Web interface to submit work for an
  assignment.
- The course instructor can then review the submissions for an assignment, and
  take appropriate actions, such as commenting or marking the assignment as
  completed.

### Github Integration

- After a student makes a submission for an assignment, an instructor needs
  to review the student's code. For this reason, University Web shows the
  student's github commit activity on the submissions page.
- In order to configure this integration, the student should set their
  github username on the profile page and set the github repository specific to
  each assignment on the submissions page.
- Once configured, University Web will periodically check for new github commits.
  It may take up to 15 minutes before new commits will appear on the submissions
  page.

## Contributing

Features and bugs are tracked through [Github Issues](https://github.com/mendicant-university/university-web/issues).

Contributors retain copyright to their work but must agree to release their
contributions under the [Affero GPL version 3](http://www.gnu.org/licenses/agpl.html)

If you would like to help with developing University Web, please get in touch!
Our contact details are at the top of this file.

### Submitting a Pull Request

1. If a ticket doesn't exist for your bug or feature, create one on GitHub.
    - _NOTE: Don't be afraid to get feedback on your idea before you begin development work._
2. Fork the project.
3. Create a topic branch.
4. Implement your feature or bug fix.
5. Add documentation for your feature or bug fix.
6. Add tests for your feature or bug fix.
7. Run `rake test`. If your changes are not 100% covered, go back to step 5.
8. If your change affects something in this README, please update it
9. Commit and push your changes.
10. Submit a pull request.

### Contributors

Jordan Byron // [jordanbyron.com](http://jordanbyron.com) <br/>
Gregory Brown // [majesticseacreature.com](http://majesticseacreature.com/)

[Full List](https://github.com/mendicant-university/university-web/contributors)

------

University Web - a [Mendicant University](http://mendicantuniversity.org) project
