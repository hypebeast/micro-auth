local config = require("lapis.config").get()
local lapis_util = require("lapis.util")
local http = require("lapis.nginx.http")
local utils = require("utils")

local GITHUB_LOGIN_BASE_URL = "https://github.com/login/oauth"

local _M = {}


function _M.authorize()
  local url = GITHUB_LOGIN_BASE_URL .. "/authorize"
  local qs = {
    client_id = config.github.client_id,
    redirect_uri = config.app_url .. "/auth/github/callback"
  }

  return utils.createRedirectHTML(url, qs)
end

function _M.callback(self)
  local code = self.params.code

  if code == nil or code == "" then
    return {utils.createRedirectHTML(config.github.redirect_uri, { error = "no code found"}), status = 401}
  end

  local githubUrl = GITHUB_LOGIN_BASE_URL .. "/access_token"

  local body, status_code, headers = http.simple({
    url = githubUrl,
    method = "POST",
    headers = {
      ["Accept"] = "application/json",
      ["content-type"] = "application/x-www-form-urlencoded"
    },
    body = {
      client_id = config.github.client_id,
      client_secret = config.github.client_secret,
      code = code
    }
  })

  if status_code == 200 then
    local data = lapis_util.from_json(body)

    if data.error ~= nil then
      return {utils.createRedirectHTML(config.github.redirect_uri, { error = data.error_description }), status = 401}
    end

    return {utils.createRedirectHTML(config.github.redirect_uri, { access_token = data.access_token }), status = 200}
  elseif status_code == 500 then
    return {utils.createRedirectHTML(config.github.redirect_uri, { error = "Github server error" }), status = 500}
  else
    return {utils.createRedirectHTML(config.github.redirect_uri, { error = "Please provide required environment variable" }), status = 500}
  end
end

return _M
