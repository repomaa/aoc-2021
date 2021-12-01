require "athena-console"
require "./commands/*"

module AoC
  VERSION = "2021.1.1"

  application = ACON::Application.new("AoC", version: VERSION)

  {% for klass in Commands::Base.subclasses %}
    application.add({{klass}}.new)
  {% end %}

  application.run
end
