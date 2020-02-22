# frozen_string_literal: true

require "action_dispatch/routing/mapper"

module HumanRoutes
  require_relative "human_routes/version"
  require_relative "human_routes/extensions"
  require_relative "human_routes/context"

  ActionDispatch::Routing::Mapper.include(Extensions)
end
