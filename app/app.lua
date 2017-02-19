local lapis = require("lapis")

local github = require("github")
local google = require("google")

local app = lapis.Application()


-- Github authorization
app:get("/auth/github", github.authorize)
app:get("/auth/github/callback", github.callback)

-- Google authorization
app:get("/auth/google", google.authorize)
app:get("/auth/google/callback", google.callback)


return app
