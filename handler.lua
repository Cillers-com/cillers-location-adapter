local BasePlugin = require "kong.plugins.base_plugin"
local ngx = ngx

local CillersLocationAdapterHandler = BasePlugin:extend()

CillersLocationAdapterHandler.VERSION = "1.0.0"
CillersLocationAdapterHandler.PRIORITY = 1000

function CillersLocationAdapterHandler:new()
  CillersLocationAdapterHandler.super.new(self, "cillers-location-adapter")
end

function CillersLocationAdapterHandler:header_filter(conf)
  CillersLocationAdapterHandler.super.header_filter(self)

  local location = ngx.header["Location"]
  local status = ngx.status

  if location and (status == 301 or status == 302 or status == 307 or status == 308) then
    local protocol, domain, path = location:match("^(https?)://([^/]+)(/.*)")

    if protocol and domain and path then
      local external_domain = conf.external_domain or domain
      local external_basepath = conf.external_basepath or ""

      -- Concatenate new location
      local external_location = protocol .. "://" .. external_domain .. external_basepath .. path

      -- Set the new Location header
      ngx.header["Location"] = external_location
    end
  end
end

return CillersLocationAdapterHandler

