local M = {}

function M.setup()
  local present, yop = pcall(require, "yop")
  if not present then
    return
  end

  yop.op_map({ "n", "v" }, "<M-a>", function(lines)
    -- Multiple lines can't be searched for
    if #lines > 1 then
      return
    end
    require("telescope.builtin").grep_string { search = lines[1] }
  end)
end

return M
