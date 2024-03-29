# human_routes

I never liked REST routing for customer-facing web pages, and until then I've
been doing it manually, with `get/post` helpers. This gem extracts some helpers
so I don't have to keep doing it manually. I never use the same controllers
responding to multiple formats anyway, as I like to keep API in a separate
endpoint.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "human_routes"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install human_routes
```

## Usage

After loading this gem, you'll have a `route` method available on your routes.

```ruby
Rails.application.routes.draw do
  route :signup do
    create
  end
end
```

This will generate a few routes different routes, as you can see below:

```console
$ rails routes
   Prefix     Verb   URI Pattern   Controller#Action
   new_signup GET    /signup/new   signup#new
              POST   /signup/new   signup#create
```

Notice that routes are generated without the optional `:format` param. Just
awesome!

A classic "resource" would be represented like this:

```ruby
Rails.application.routes.draw do
  route :blogs do
    create
    update
    remove
    list
    show
  end
end
```

The above could added in one line with `route(:blogs) { all }`.

This will generate the following routes:

```console
$ rails routes
     Prefix Verb   URI Pattern        Controller#Action
   new_blog GET    /blogs/new         blogs#new
            POST   /blogs/new         blogs#create
  edit_blog GET    /blogs/:id/edit    blogs#edit
            POST   /blogs/:id/edit    blogs#update
remove_blog GET    /blogs/:id/remove  blogs#remove
            POST   /blogs/:id/remove  blogs#destroy
      blogs GET    /blogs             blogs#index
       blog GET    /blogs/:id         blogs#show
```

The API is quite simple and delegated to
[ActionDispatch::Routing::Mapper::Base#match](https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-match).

```ruby
# `options` will be applied to every single route in the block.
# Can be used to set `format: true`, or `param: :another_id`.
routes(options = {}, &block)

# Each of the route generators accepts its own path and options.
# Use it to override the path or set a different named route.
create(path, &options)
update(path, &options)
remove(path, &options)
list(path, &options)
show(path, &options)

# In practice, something along these lines.
Rails.application.routes.draw do
  route :signup do
    # This will generate the helper `signup_path` instead of `new_signup_path`.
    # The route will also be modified to `/signup` instead of `/signup/new`.
    create "signup", as: "signup"
  end

  route :pages, module: "customer" do
    all
  end

  # Additionally, you can use `:name` to give a different name to
  # namespaced controllers. This way routes can be generated using a shallow
  # path instead of the usual `admin/reports`.
  route "admin/reports", name: "reports" do
    all
  end

  # Singular routes also are detected and generated accordingly.
  # This will generate the following routes:
  #
  # GET  /profile         profile_path
  # GET  /profile/new     new_profile_path
  # POST /profile/new
  # GET  /profile/edit    edit_profile_path
  # POST /profile/edit
  # GET  /profile/remove  remove_profile_path
  # POST /profile/remove
  route "profile" do
    all
  end

  # You can use `resource: true` when you want a plural route but need a
  # singular resource.
  #
  # GET  /settings         settings_path
  # GET  /settings/new     new_settings_path
  # POST /settings/new
  # GET  /settings/edit    edit_settings_path
  # POST /settings/edit
  # GET  /settings/remove  remove_settings_path
  # POST /settings/remove
  #
  route "settings", resource: true do
    all
  end
end
```

Sometimes you want to create routes without the action (e.g. `new` or `edit`);
in this case, you can use `bare: true`.

```ruby
Rails.application.routes.draw do
  # This will generate the following routes:
  #
  # GET  /login  new_login_path
  # POST /login
  route :login do
    create bare: true
  end
end
```

You may want to add another paths not covered by the default helpers. In that
case, you can use `get` and `post`.

```ruby
Rails.application.routes.draw do
  route :login do
    create as: "login", bare: true
    get :verify_email #=> /login/verify-email
    get :check_inbox  #=> /login/check-inbox
  end
end
```

For nested paths, you can use `:prefix`:

```ruby
Rails.application.routes.draw do
  route :posts do
    all
  end

  route :comments, prefix: "posts/:post_id" do
    remove #=> /posts/:post_id/comments/:id/remove
    list   #=> /posts/:post_id/comments

    # or
    all
  end
end
```

If you need to change the url path, but point to a different controller, then
use `:path_name`:

```ruby
Rails.application.routes.draw do
  route :blogs do
    all
  end

  route :blog_comments, path: "blogs/:blog_id", path_name: "comments" do
    all
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/fnando/human_routes>. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the
[code of conduct](https://github.com/fnando/human_routes/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HumanRoutes project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/human_routes/blob/master/CODE_OF_CONDUCT.md).
