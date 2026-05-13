return {
  init_options = {
    typescript = {
      tsdk = vim.fn.trim(vim.fn.system("npm root -g")) .. "/typescript/lib", -- npm install -g typescript
    },
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
