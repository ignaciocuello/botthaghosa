# README

### About

Botthaghosa is a simple discord bot, with a companion web service, that 
aims to simplify and automate some of the tasks required to carry out the
online sutta discussions at BSV.

### Installation

You will need to have ruby 3.3.0 or greater installed.

You will also have to install postgresql and redis.

You'll also have to request `master.key`.

1. `git clone git@github.com:ignaciocuello/botthaghosa.git`
2. `gem install bundler`
3. `cd botthaghosa`
4. `bundle install`
5. copy shared `master.key` into `config/master.key`
6. `rails db:create`
7. `rails db:migrate`

#### MacOS only
1. `brew services start postgresql`
2. `brew services start redis`

You will need to have sidekiq running on the side for async jobs.
`bundle exec sidekiq`

Run the server and start the bot.
`rails server`

### Running Tests

`rails t`

### Deploying

Deploys automatically on `render.com` with pushes to main.
