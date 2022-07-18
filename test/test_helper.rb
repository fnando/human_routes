# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "bundler/setup"
require "rails"
require "action_controller/railtie"
require "human_routes"

require "minitest/utils"
require "minitest/autorun"

class App < Rails::Application
  config.eager_load = false
end

class ThingsController < ActionController::Base
  def show
    render plain: "#{__method__}:#{params[:id]}"
  end

  def index
    render plain: __method__.to_s
  end

  def new
    render plain: __method__.to_s
  end

  def create
    render plain: __method__.to_s
  end

  def edit
    render plain: "#{__method__}:#{params[:id]}"
  end

  def update
    render plain: "#{__method__}:#{params[:id]}"
  end

  def remove
    render plain: "#{__method__}:#{params[:id]}"
  end

  def destroy
    render plain: "#{__method__}:#{params[:id]}"
  end
end

class SignupController < ActionController::Base
  def new
    render plain: "#{__method__}:#{params[:step]}"
  end

  def create
    render plain: "#{__method__}:#{params[:step]}"
  end
end

class CommentsController < ActionController::Base
  def show
    render plain: "#{__method__}:#{params[:post_id]}:#{params[:id]}"
  end

  def edit
    render plain: "#{__method__}:#{params[:post_id]}:#{params[:id]}"
  end

  def update
    render plain: "#{__method__}:#{params[:post_id]}:#{params[:id]}"
  end

  def remove
    render plain: "#{__method__}:#{params[:post_id]}:#{params[:id]}"
  end

  def destroy
    render plain: "#{__method__}:#{params[:post_id]}:#{params[:id]}"
  end

  def new
    render plain: "#{__method__}:#{params[:post_id]}"
  end

  def create
    render plain: "#{__method__}:#{params[:post_id]}"
  end

  def index
    render plain: "#{__method__}:#{params[:post_id]}"
  end
end

class LoginController < ActionController::Base
  def new
    render plain: __method__.to_s
  end

  def create
    render plain: __method__.to_s
  end

  def verify_email
    render plain: __method__.to_s
  end

  def check_inbox
    render plain: __method__.to_s
  end
end

module Admin
  class ReportsController < ActionController::Base
    def new
      render plain: __method__.to_s
    end
  end
end

App.initialize!

def with_routes(&block)
  Rails.application.routes.draw(&block)
end
