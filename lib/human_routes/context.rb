# frozen_string_literal: true

module HumanRoutes
  class Context
    attr_reader :controller, :options, :router, :named_routes

    def initialize(router, controller, options = {})
      @router = router
      @controller = controller
      @options = options
      @named_routes = {}
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

      match path, {
        via: :get,
        controller: controller,
        action: :new,
        as: name
      }.merge(options)

      match path, {
        via: :post,
        controller: controller,
        action: :create,
        as: ""
      }.merge(options)
    end

    def update(*args)
      path, name, options = extract_route_args(
        segment: :edit,
        default_name: "edit_#{singular_controller_name}",
        args: args
      )

      match path, {
        via: :get,
        controller: controller,
        action: :edit,
        as: name
      }.merge(options)

      match path, {
        via: :post,
        controller: controller,
        action: :update,
        as: ""
      }.merge(options)
    end

    def remove(*args)
      path, name, options = extract_route_args(
        segment: :remove,
        default_name: "remove_#{singular_controller_name}",
        args: args
      )

      match path, {
        via: :get,
        controller: controller,
        action: :remove,
        as: name
      }.merge(options)

      match path, {
        via: :post,
        controller: controller,
        action: :destroy,
        as: ""
      }.merge(options)
    end

    def list(*args)
      path, name, options = extract_route_args(
        segment: :list,
        default_name: controller_name,
        args: args
      )

      match path, {
        via: :get,
        controller: controller,
        action: :index,
        as: name
      }.merge(options)
    end

    def show(*args)
      path, name, options = extract_route_args(
        segment: :show,
        default_name: singular_controller_name,
        args: args,
        bare: true
      )

      match path, {
        via: :get,
        controller: controller,
        action: :show,
        as: name
      }.merge(options)
    end

    def all
      create
      update
      remove
      show
      list unless controller_name == controller_name.singularize
    end

    def get(action, *args)
      path, name, options = extract_route_args(
        segment: action,
        default_name: action.to_s,
        args: args
      )

      match path, {
        via: :get,
        controller: controller,
        action: action,
        as: name
      }.merge(options)
    end

    def post(action, *args)
      path, name, options = extract_route_args(
        segment: action,
        default_name: action.to_s,
        args: args
      )

      match path, {
        via: :post,
        controller: controller,
        action: action,
        as: named_routes[path] == name ? "" : name
      }.merge(options)
    end

    private def match(path, options)
      named_routes[path] = options[:as] unless options[:as].empty?
      router.match(path, options)
    end

    private def extract_route_args(
      segment:,
      default_name:,
      args:,
      bare: false
    )
      route_options = args.extract_options!
      route_options = default_options
                      .merge(bare: bare)
                      .merge(options)
                      .merge(route_options)

      path = args.first || path_for(segment, route_options)
      path = path.to_s.dasherize
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
                   resource_segments(segment, param, options)
                 else
                   resources_segments(segment, param, options)
                 end

      segments.compact.join("/")
    end

    private def resource_segments(segment, _param, options)
      segments = [controller_name]
      segments << segment unless options[:bare]
      segments
    end

    private def resources_segments(segment, param, _options)
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
