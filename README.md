# Gem Creator

Helps developers create and publish ruby gems.

## Installation

### Prerequisites

- [Nix](https://determinate.systems/posts/determinate-nix-installer).
- [Direnv](https://direnv.net/docs/installation.html).
- [Github account](https://github.com/).
- [Rubygems account](https://rubygems.org/).

## Usage

Update the value of `TARGET_DIR` within `.env.example` to the directory where you want the gem to live.

Set up the environment with `direnv allow`.

To create the gem, run `task gem:build`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sylvance/gem_creator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

