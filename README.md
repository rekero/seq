# roda-sequel for sequra
- You should have ruby and postgresql

## Setup

`bundle install`

## Database Setup

`sudo -u postgres psql`

`create user seq with password 'seq' createdb;`
`create database seq_test owner seq;`
`create database seq_development owner seq;`

## Migrations

`rake dev_up`
`rake test_up`

## How to fill data for development

`rake fill_data`

## How to run

`rackup`

After that you can make request like

`http://localhost:9292/main/disbursements?year=2018&month=1&day=1`
`http://localhost:9292/main/disbursements/3?year=2018&month=1&day=1`

If you want to access console you can use
`rake dev_irb`

## Environment Variables Used(in .env.rb)

`#{APP}_DATABASE_URL :: database connection URL to give to Sequel, default is to
                       create one based on the application's name and RACK_ENV.
#{APP}_SESSION_SECRET :: cookie session secret, must be >=64 bytes
RACK_ENV :: environment to use (production, development, or test), defaults
            to development.`

## Specs

To run the specs for the application after running `rake test_up` you can just simply write `rake`

