return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "pyrightconfig.json",
    "setup.py",
    "setup.cfg",
    "Pipfile",
    "requirements.txt",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        ignore = {"*"}, -- let ruff output diagnostics
        typeCheckingMode = "off", -- let mypy handle typechecking
      }
    }
  },
}
