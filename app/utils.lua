local Template = require ('pl.text').Template
local util = require("lapis.util")


local _M = {}

function _M.createRedirectHTML(url, data)
  local htmlTemplate = [[<!DOCTYPE html>
          <meta charset=utf-8>
          <title>Redirecting…</title>
          <meta http-equiv=refresh content='0;URL=${url}'>
          <script>location="${url}"</script>]]
  local t = Template(htmlTemplate)

  return t:substitute {url = url .. "?" .. util.encode_query_string(data)}
end

return _M
