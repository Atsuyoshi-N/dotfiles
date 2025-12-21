return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,

  config = function ()
    local function shorten_path()
      local path = vim.fn.expand('%:p')
      local home = vim.fn.expand('~')

      -- ホームディレクトリからの相対パスに変換
      if path:sub(1, #home) == home then
        path = '~' .. path:sub(#home + 1)
      end

      -- パスを短縮（ディレクトリを頭文字に）
      local parts = vim.split(path, '/')
      if #parts > 3 then
        for i = 2, #parts - 1 do
          if parts[i] ~= '~' and parts[i] ~= '' then
            parts[i] = parts[i]:sub(1, 1)
          end
        end
      end

      return table.concat(parts, '/')
    end

    local function fileformat_with_name()
      local format = vim.bo.fileformat
      local format_map = {
        unix = 'LF',
        dos = 'CRLF',
        mac = 'CR'
      }
      return format_map[format] or format
    end

    require("lualine").setup({
      options = {
        theme = "iceberg_dark",
      },
      sections = {
        lualine_c = {
          { shorten_path }
        },
        lualine_x = {
          'encoding',
          { fileformat_with_name },
          'filetype'
        }
      }
    })
  end
}
