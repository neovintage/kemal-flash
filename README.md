# kemal-flash

`kemal-flash` provides a way to pass temporary information between actions. Anything
that's placed in the flash will be cleared out at the end of the next action. `kemal-flash`
depends on `kemal-session`. Make sure `kemal-session` is included before including
`kemal-flash`.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  kemal-flash:
    github: neovintage/kemal-flash
    version: 0.1.0
```

## Usage

```crystal
require "kemal-flash"

get "/" do |env|
  env.flash["notice"] = "welcome"
end

get "/check_flash" do |env|
  env.flash["notice"]?
end
```

## Contributing

1. Fork it ( https://github.com/[your-github-name]/kemal-flash/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Run `crystal spec` for all spec pass
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[neovintage]](https://github.com/neovintage) Rimas Silkaitis - creator, maintainer
