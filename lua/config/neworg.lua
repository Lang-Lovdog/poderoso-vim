require("neorg").setup {
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          hataraki = "~/Documents/oShigoto/HatarakiNotes",
        },
        default_workspace = "hataraki",
      },
    },
  },
}
