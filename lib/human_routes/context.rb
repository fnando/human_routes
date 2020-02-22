# frozen_string_literal: true

module HumanRoutes
  class Context
    attr_reader :controller
    attr_reader :options

    def initialize(controller, options = {})
      @controller = controller
      @options = options
    end

    def singular_controller_name
      @singular_controller_name ||= controller.to_s.singularize
    end

    def routes
      @routes ||= []
    end

    def create(*args)
      path, name, options = extract_route_args(
        default_path: "#{controller}/new",
        default_name: "new_#{singular_controller_name}",
        args: args
      )

      routes << [
        path,
        {
          via: :get,
          controller: controller,
          action: :new,
          as: name
        }.merge(options)
      ]

      routes << [
        path,
        {
          via: :post,
          controller: controller,
          action: :create,
          as: ""
        }.merge(options)
      ]
    end

    def update(*args)
      path, name, options = extract_route_args(
        default_path: "#{controller}/:id/edit",
        default_name: "edit_#{singular_controller_name}",
        args: args
      )

      routes << [
        path,
        {
          via: :get,
          controller: controller,
          action: :edit,
          as: name
        }.merge(options)
      ]

      routes << [
        path,
        {
          via: :post,
          controller: controller,
          action: :update,
          as: ""
        }.merge(options)
      ]
    end

    def remove(*args)
      path, name, options = extract_route_args(
        default_path: "#{controller}/:id/remove",
        default_name: "remove_#{singular_controller_name}",
        args: args
      )

      routes << [
        path,
        {
          via: :get,
          controller: controller,
          action: :remove,
          as: name
        }.merge(options)
      ]

      routes << [
        path,
        {
          via: :post,
          controller: controller,
          action: :destroy,
          as: ""
        }.merge(options)
      ]
    end

    def list(*args)
      path, name, options = extract_route_args(
        default_path: controller,
        default_name: controller,
        args: args
      )

      routes << [
        path,
        {
          via: :get,
          controller: controller,
          action: :index,
          as: name
        }.merge(options)
      ]
    end

    def show(*args)
      path, name, options = extract_route_args(
        default_path: "#{controller}/:id",
        default_name: singular_controller_name,
        args: args
      )

      routes << [
        path,
        {
          via: :get,
          controller: controller,
          action: :show,
          as: name
        }.merge(options)
      ]
    end

    def all
      create
      update
      remove
      list
      show
    end

    private def extract_route_args(default_path:, default_name:, args:)
      route_options = args.extract_options!
      route_options = default_options.merge(options).merge(route_options)
      path = args.first || default_path
      name = route_options.delete(:as) || default_name

      [path, name, route_options]
    end

    private def default_options
      {
        format: false
      }
    end
  end
end
