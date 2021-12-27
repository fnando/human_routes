# frozen_string_literal: true

require "test_helper"

class HumanRoutesTest < Minitest::Test
  include Rack::Test::Methods
  include Rails.application.routes.url_helpers

  def app
    App
  end

  test "defines :create routes for things" do
    with_routes do
      route :things do
        create
      end
    end

    get new_thing_path

    assert_equal "/things/new", last_request.path
    assert_equal "new", last_response.body

    post new_thing_path

    assert_equal "/things/new", last_request.path
    assert_equal "create", last_response.body
  end

  test "defines :update routes for things" do
    with_routes do
      route :things do
        update
      end
    end

    get edit_thing_path(1234)

    assert_equal "/things/1234/edit", last_request.path
    assert_equal "edit:1234", last_response.body

    post edit_thing_path(1234)

    assert_equal "/things/1234/edit", last_request.path
    assert_equal "update:1234", last_response.body
  end

  test "defines :remove routes for things" do
    with_routes do
      route :things do
        remove
      end
    end

    get remove_thing_path(1234)

    assert_equal "/things/1234/remove", last_request.path
    assert_equal "remove:1234", last_response.body

    post remove_thing_path(1234)

    assert_equal "/things/1234/remove", last_request.path
    assert_equal "destroy:1234", last_response.body
  end

  test "defines :list routes for things" do
    with_routes do
      route :things do
        list
      end
    end

    get things_path

    assert_equal "/things", last_request.path
    assert_equal "index", last_response.body
  end

  test "defines :show routes for things" do
    with_routes do
      route :things do
        show
      end
    end

    get thing_path(1234)

    assert_equal "/things/1234", last_request.path
    assert_equal "show:1234", last_response.body
  end

  test "generates route with custom path for :create" do
    with_routes do
      route :signup do
        create "signup(/:step)"
      end
    end

    get new_signup_path("info")

    assert_equal "/signup/info", last_request.path
    assert_equal "new:info", last_response.body

    post new_signup_path("billing")

    assert_equal "/signup/billing", last_request.path
    assert_equal "create:billing", last_response.body
  end

  test "generates route with custom :as for :create" do
    with_routes do
      route :login do
        create as: "auth"
      end
    end

    get auth_path

    assert_equal "/login/new", last_request.path
    assert_equal "new", last_response.body

    post auth_path

    assert_equal "/login/new", last_request.path
    assert_equal "create", last_response.body
  end

  test "generates all routes with shortcut" do
    with_routes do
      route :things do
        all
      end
    end

    assert_equal "/things/new", new_thing_path
    assert_equal "/things/1234/edit", edit_thing_path(1234)
    assert_equal "/things/1234/remove", remove_thing_path(1234)
    assert_equal "/things/1234", thing_path(1234)
    assert_equal "/things", things_path

    get new_thing_path

    assert_equal "/things/new", last_request.path
    assert_equal "new", last_response.body
  end

  test "generates routes with module namespace" do
    with_routes do
      route "admin/reports" do
        create
        update
        remove
        list
        show
      end
    end

    assert_equal "/admin/reports/new", new_admin_report_path
    assert_equal "/admin/reports/1234/edit", edit_admin_report_path(1234)
    assert_equal "/admin/reports/1234/remove", remove_admin_report_path(1234)
    assert_equal "/admin/reports/1234", admin_report_path(1234)
    assert_equal "/admin/reports", admin_reports_path

    get new_admin_report_path

    assert_equal "/admin/reports/new", last_request.path
    assert_equal "new", last_response.body
  end

  test "generates routes using controller options" do
    with_routes do
      route :things, format: true do
        show
        list
      end
    end

    get thing_path(1234, :json)

    assert_equal "/things/1234.json", last_request.path
    assert_equal "show:1234", last_response.body

    get things_path(:json)

    assert_equal "/things.json", last_request.path
    assert_equal "index", last_response.body
  end

  test "generates routes using base name for namespaced controllers" do
    with_routes do
      route "admin/reports", name: "reports" do
        all
      end
    end

    assert_equal "/reports/new", new_report_path
    assert_equal "/reports/1234/edit", edit_report_path(1234)
    assert_equal "/reports/1234/remove", remove_report_path(1234)
    assert_equal "/reports/1234", report_path(1234)
    assert_equal "/reports", reports_path
  end

  test "generates routes with singular name" do
    with_routes do
      route "profile" do
        all
      end
    end

    assert_equal "/profile/new", new_profile_path
    assert_equal "/profile/edit", edit_profile_path
    assert_equal "/profile/remove", remove_profile_path
    assert_equal "/profile", profile_path
  end

  test "generates bare routes" do
    with_routes do
      route "login" do
        create bare: true
      end
    end

    get new_login_path

    assert_equal "/login", last_request.path
    assert_equal "new", last_response.body

    post new_login_path

    assert_equal "/login", last_request.path
    assert_equal "create", last_response.body
  end
end
