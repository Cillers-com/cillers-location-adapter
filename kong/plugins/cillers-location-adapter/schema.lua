return {
  name = "cillers-location-adapter",
  fields = {
    { config = {
        type = "record",
        fields = {
          { external_domain = { type = "string", required = true } },
          { external_basepath = { type = "string", default = "" } },
        },
      },
    },
  },
}
