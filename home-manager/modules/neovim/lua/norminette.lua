local M = {}

local function parse_output(lines)
  local items = {}
  local current_file = nil

  for _, line in ipairs(lines) do
    local file = line:match("^(.-): Error!$")

    if file then
      current_file = file
    else
      local code, lnum, col, message =
        line:match(
          "^Error:%s+([%w_]+)%s+%(line:%s*(%d+),%s*col:%s*(%d+)%)%:%s*(.*)$"
        )

      if code and current_file then
        items[#items + 1] = {
          filename = current_file,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = code .. ": " .. message,
          type = "E",
        }
      end
    end
  end

  return items
end

local function run(target, title)
  vim.system(
    {
      "norminette",
      "--no-colors",
      target,
    },
    {
      text = true,
    },
    function(result)
      vim.schedule(function()
        local stdout = result.stdout or ""
        local stderr = result.stderr or ""

        local lines = vim.split(stdout, "\n", {
          trimempty = true,
        })

        local items = parse_output(lines)

        if #items == 0 then
          if result.code == 0 then
            vim.fn.setqflist({}, "r")
            vim.notify("Norminette: OK", vim.log.levels.INFO)
          else
            local message = stderr ~= "" and stderr or stdout

            vim.notify(
              "Norminette failed:\n" .. message,
              vim.log.levels.ERROR
            )
          end

          return
        end

        vim.fn.setqflist({}, " ", {
          title = title,
          items = items,
        })

        vim.cmd("copen")
      end)
    end
  )
end

function M.file()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("Norminette: buffer has no file", vim.log.levels.WARN)
    return
  end

  if not file:match("%.c$") and not file:match("%.h$") then
    vim.notify("Norminette: not a C/header file", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end

  run(file, "Norminette: " .. vim.fn.fnamemodify(file, ":t"))
end

function M.directory()
  local file = vim.api.nvim_buf_get_name(0)

  local directory =
    file ~= ""
    and vim.fn.fnamemodify(file, ":p:h")
    or vim.fn.getcwd()

  run(directory, "Norminette: " .. directory)
end

vim.api.nvim_create_user_command("Norminette", M.file, {})
vim.api.nvim_create_user_command("NorminetteDir", M.directory, {})

return M
