# Coffeebox

This is an opinionated rewrite of [Facebox](http://defunkt.github.com/facebox/).

## Features

1. Everything is converted to coffescript
2. Shipped as a Rails 3.2/4.0 asset pipeline compatible gem
3. Includes [spin.js](http://fgnass.github.io/spin.js/) instead of a gif preloader
4. Preloads images with [imgpreload](https://github.com/farinspace/jquery.imgpreload)
5. Built-in support for turbolinks
6. Support for fully custom popup HTML
7. Does not stay in DOM when closed

## Installation

Add this line to your application's Gemfile:

    gem 'coffeebox'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coffeebox

## Usage

require it in application.js.coffee:

    #= require coffeebox

and in application.css.sass:

    //= require coffeebox

or (sass\scss only)

    @import coffeebox

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
