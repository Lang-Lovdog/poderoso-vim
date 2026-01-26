-- Liveshare config for nvim

require("live-share").setup({
    port_internal = 9876,
    max_attempts = 20,
    service_url = "/tmp/service.url",
    service = "nokey@localhost.run"
  })
