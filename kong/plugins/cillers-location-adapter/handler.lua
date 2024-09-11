local CillersLocationAdapterHandler = {
  VERSION = "1.0.1",
  PRIORITY = 1000,
}

function CillersLocationAdapterHandler:header_filter(conf)
  local location = ngx.header["Location"]
  local status = ngx.status
  if location and (status == 301 or status == 302 or status == 307 or status == 308) then
    local protocol, domain, path = location:match("^(https?)://([^/]+)(/.*)")
    if protocol and domain and path then
      local external_domain = conf.external_domain or domain
      local external_basepath = conf.external_basepath or ""
      local external_location = protocol .. "://" .. external_domain .. external_basepath .. path
      ngx.header["Location"] = external_location
    end
  end
end

