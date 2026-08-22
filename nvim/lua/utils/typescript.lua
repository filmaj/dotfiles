local M = {}

function M.read_typescript_install(package_dir, source)
  local package_json = vim.fs.joinpath(package_dir, "package.json")

  local ok, content = pcall(vim.fn.readfile, package_json)

  if not ok or not content or #content == 0 then
    return nil
  end

  local ok_decode, pkg = pcall(
    vim.json.decode,
    table.concat(content, "\n")
  )

  if not ok_decode or not pkg or not pkg.version then
    return nil
  end

  local major = tonumber(pkg.version:match("^(%d+)"))

  if not major then
    return nil
  end

  return {
    version = pkg.version,
    major = major,
    source = source,

    package_dir = package_dir,

    tsserver_path = vim.fs.joinpath(
      package_dir,
      "lib",
      "tsserver.js"
    ),

    tsc_path = vim.fs.joinpath(
      package_dir,
      "bin",
      "tsc"
    ),
  }
end

function M.find_local_typescript(root_dir)
  return M.read_typescript_install(
    vim.fs.joinpath(
      root_dir,
      "node_modules",
      "typescript"
    ),
    "local"
  )
end

local global_typescript

function M.find_global_typescript()
  if global_typescript ~= nil then
    return global_typescript or nil
  end

  local result = vim.system(
    { "npm", "root", "-g" },
    { text = true }
  ):wait()

  if result.code ~= 0 then
    global_typescript = false
    return nil
  end

  local npm_root = vim.trim(result.stdout)

  if npm_root == "" then
    global_typescript = false
    return nil
  end

  global_typescript =
      M.read_typescript_install(
        vim.fs.joinpath(
          npm_root,
          "typescript"
        ),
        "global"
      )
      or false

  return global_typescript or nil
end

local typescript_cache = {}

function M.get_typescript(root_dir)
  if typescript_cache[root_dir] ~= nil then
    return typescript_cache[root_dir] or nil
  end

  local ts =
      M.find_local_typescript(root_dir)
      or M.find_global_typescript()

  typescript_cache[root_dir] = ts or false

  return ts
end

function M.find_ts_root(bufnr)
  return vim.fs.root(bufnr, {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  })
end

return M
