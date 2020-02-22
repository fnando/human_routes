# frozen_string_literal: true

module HumanRoutes
  class Context
    attr_reader :controller
    attr_reader :options

    def initialize(controller, options = {})
      @controller = controller
      @options = options
    end

    def controller_name
      @controller_name ||= options.delete(:name) { controller.to_s }
    end

    def singular_controller_name
      @singular_controller_name ||= controller_name.singularize
    end

    def resource?
      controller_name == singular_controller_name
    end

    def routes
      @routes ||= []
    end

    def create(*args)
      path, name, options = extract_route_args(
        segment: :new,
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
        segment: :edit,
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
        segment: :remove,
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
        segment: :list,
        default_name: controller_name,
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
        segment: :show,
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
      show
      list unless controller_name == controller_name.singularize
    end

    private def extract_route_args(segment:, default_name:, args:)
      route_options = args.extract_options!
      route_options = default_options.merge(options).merge(route_options)
      path = args.first || path_for(segment, route_options)
      name = route_options.delete(:as) { default_name.underscore.tr("/", "_") }

      [path, name, route_options]
    end

    private def default_options
      {
        format: false
      }
    end

    private def path_for(segment, options)
      param = options.fetch(:param, :id)

      segments = if resource?
                   resource_segments(segment, param)
                 else
                   resources_segments(segment, param)
                 end

      segments.compact.join("/")
    end

    private def resource_segments(segment, _param)
      segments = [controller_name]
      segments << segment unless segment == :show
      segments
    end

    private def resources_segments(segment, param)
      case segment
      when :list
        [controller_name]
      when :new
        [controller_name, segment]
      when :show
        [controller_name, ":#{param}"]
      else
        [controller_name, ":#{param}", segment]
      end
    end
  end
end
