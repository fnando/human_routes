# frozen_string_literal: true

module HumanRoutes
  module Extensions
    def route(controller, options = {}, &)
      context = Context.new(self, controller, options)
      context.instance_eval(&)
    end
  end
end
