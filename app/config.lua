-- config.lua
local config = require("lapis.config")

config({"development", "production"}, {
  app_url = os.getenv("APP_URL") or "http://localhost:8080",
  github = {
    client_id = os.getenv("GITHUB_CLIENT_ID"),
    client_secret = os.getenv("GITHUB_CLIENT_SECRET"),
    redirect_uri = os.getenv("GITHUB_REDIRECT_URL")
  },
  google = {
    client_id = os.getenv("GOOGLE_CLIENT_ID"),
    client_secret = os.getenv("GOOGLE_CLIENT_SECRET"),
    redirect_uri = os.getenv("GOOGLE_REDIRECT_URL"),
    scope = os.getenv("GOOGLE_SCOPE") or "https://www.googleapis.com/auth/plus.me"
  }
})

config("development", {
  port = 8080,
  code_cache = "off"
})

config("production", {
  port = 8080,
  code_cache = "on"
})
