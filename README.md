# Toke

Toke is a Rails engine that is designed to be mounted in a Rails API and provides
simple token based authentication. Toke provides a user model and restful JSON routes for
registering new users, logging in, and logging out. Toke will return a JSON Web Token (JWT) upon
successfull login, which will be required for any actions that you choose to secure by using the
provided `before_action toke!`

### Install

    gem install toke
  
or in a your Gemfile:

    gem 'toke', '~> 0.1.0'

#### Install the migrations

Toke uses two Active Record models: `Toke::User` and `Toke::Token`. `Users` have one (`has_one`) `Token` and
`Tokens` belong to (`belong_to`) `Users`. The tables for the models are `toke_users` and `toke_tokens`. To
copy the two migrations into your application's `db/migrate` directory, that will create these tables, run the
following rake command:

    rake install:toke:migrations

Feel free to add additional fields to these migrations, but don't remove anything, all are required. Migrate
your datebase as usual:

    rake db:migrate

### User Registration

### Log In

### Securing a controller action

### Log Out
