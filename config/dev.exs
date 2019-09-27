use Mix.Config

# Configure your database
config :sgim, Sgim.Repo,
  database: "concar",
  username: "sa",
  password: "Halcones66",
  hostname: "192.0.0.139",
  instance_name: "SQLEXPRESS",
  port:          "1433",
  pool_size:     10,
  odbc_driver:   "{ODBC Driver 17 for SQL Server}",
  show_sensitive_data_on_connection_error: true

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :sgim, SgimWeb.Endpoint,
  http: [port: 4000],
  https: [
    port: 4001,
    cipher_suite: :strong,
    certfile: "priv/cert/selfsigned.pem",
    keyfile: "priv/cert/selfsigned_key.pem"
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

#WARNING: only use the generated certificate for testing in a closed network
#environment, such as running a development server on `localhost`.
#For production, staging, or testing servers on the public internet, obtain a
#proper certificate, for example from [Let's Encrypt](https://letsencrypt.org).
#
#NOTE: when using Google Chrome, open chrome://flags/#allow-insecure-localhost
#to enable the use of self-signed certificates on `localhost`.

# Watch static and templates for browser reloading.
config :sgim, SgimWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/sgim_web/{live,views}/.*(ex)$",
      ~r"lib/sgim_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
