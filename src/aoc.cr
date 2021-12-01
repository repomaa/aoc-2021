require "athena-console"
require "./commands/*"
require "dotenv"

module AoC
  VERSION = "2021.1.1"

  Dotenv.load?

  application = ACON::Application.new("AoC", version: VERSION)

  application.add(Commands::FetchInput.new)

  {% for klass in Commands::Base.subclasses %}
    application.add({{klass}}.new)
  {% end %}

  application.run
end
