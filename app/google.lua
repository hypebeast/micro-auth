local config = require("lapis.config").get()
local lapis_util = require("lapis.util")
local http = require("lapis.nginx.http")
local utils = require("utils")


local _M = {}

function _M.authorize()
  local url = "https://accounts.google.com/o/oauth2/v2/auth"
  local scope = config.google.scope
  local qs = {
    client_id = config.google.client_id,
    redirect_uri = config.app_url .. "/auth/google/callback",
    response_type = "code",
    scope = scope
  }

  return utils.createRedirectHTML(url, qs)
end

function _M.callback(self)
  local googleAuthUrl = "https://www.googleapis.com/oauth2/v4/token"
  local code = self.params.code
  local error = self.params.error

  if code == nil or code == "" or error then
    return {utils.createRedirectHTML(config.google.redirect_uri, { error = "access denied"}), status = 401}
  end

  local body, status_code, headers = http.simple({
    url = googleAuthUrl,
    method = "POST",
    headers = {
      ["Accept"] = "application/json",
      ["content-type"] = "application/x-www-form-urlencoded"
    },
    body = {
      client_id = config.google.client_id,
      client_secret = config.google.client_secret,
      code = code,
      grant_type = "authorization_code",
      redirect_uri = config.app_url .. "/auth/google/callback"
    }
  })

  if status_code == 200 then
    local data = lapis_util.from_json(body)

    if data.error ~= nil then
      return {utils.createRedirectHTML(config.google.redirect_uri, { error = data.error_description }), status = 401}
    end

    local resp = {
      access_token = data.access_token,
      refresh_token = data.refresh_token,
      expires_in = data.expires_in
    }
    return {utils.createRedirectHTML(config.google.redirect_uri, resp), status = 200}
  elseif status_code == 500 then
    return {utils.createRedirectHTML(config.google.redirect_uri, { error = "Google server error" }), status = 500}
  else
    return {utils.createRedirectHTML(config.google.redirect_uri, { error = "Please provide required environment variable" }), status = 500}
  end
end

return _M
