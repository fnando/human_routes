# frozen_string_literal: true

module HumanRoutes
  module Extensions
    def route(controller, options = {}, &block)
      context = Context.new(self, controller, options)
      context.instance_eval(&block)
    end
  end
end
