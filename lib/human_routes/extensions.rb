# frozen_string_literal: true

module HumanRoutes
  module Extensions
    def route(controller, options = {}, &block)
      context = Context.new(controller, options)
      context.instance_eval(&block)

      context.routes.each do |route|
        match(*route)
      end
    end
  end
end
