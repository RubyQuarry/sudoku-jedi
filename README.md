# Sudoku Jedi
[![Build Status](https://travis-ci.org/RubyQuarry/sudoku-jedi.svg?branch=master)](https://travis-ci.org/RubyQuarry/sudoku-jedi)
[![Coverage Status](https://coveralls.io/repos/RubyQuarry/sudoku_solver/badge.png)](https://coveralls.io/r/RubyQuarry/sudoku_solver)
[![Gem Version](https://badge.fury.io/rb/sudoku-jedi.svg)](http://badge.fury.io/rb/sudoku-jedi)

Currently solves easy to moderate sudoku puzzles in a flash!
This sudoku solver implementation uses solution tactics such as naked pairs, hidden pairs, box/line reduction, and X-wing strategies for tougher puzzles.
You can read about these techniques [here](http://www.sudokuwiki.org/sudoku.htm)

## Installation

Add this line to your application's Gemfile:


```ruby
gem 'sudoku-jedi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sudoku-jedi

## Usage

Sudoku-Jedi can solve sodokus for you.  All you have to do is put a sudoku in a text with zeros marked as the 
empty cells for example: a.txt
```
043080250
600000000
000001094
900004070
000608000
010200003
820500000
000000005
034090710
```

Then calling
```
sudoku-jedi solve a.txt
```
will result in your printed answer in the terminal.


## Contributing

1. Fork it ( https://github.com/RubyQuarry/sudoku_solver/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request



####Questions, Concerns, Flat out mistakes?  Feel free to contact me.

> [Contact me (applejuiceteaching@gmail.com)](mailto:applejuiceteaching@gmail.com)
