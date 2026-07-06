-- Node / TypeScript debugging (nvim-dap + js-debug)
-- Auto-loaded by lua/custom/plugins/init.lua.
--
-- Depends on: kickstart.plugins.debug (loads nvim-dap) + the `js-debug-adapter`
-- Mason package (added to ensure_installed in init.lua).
--
-- nvim-dap reads `.vscode/launch.json` automatically, so your existing
-- "Attach: core" / "Attach: projection" / ... configs in the snapcaster backend
-- show up in the picker when you press <F5> inside a .ts file there. All this
-- file does is (1) register the JS debug adapter and (2) tell nvim-dap that
-- launch.json entries of "type": node apply to JavaScript/TypeScript files.

local ok, dap = pcall(require, 'dap')
if not ok then
  return
end

-- js-debug runs as a small server; nvim-dap starts it on a free ${port}.
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'js-debug-adapter', -- installed by Mason, on nvim's PATH
    args = { '${port}' },
  },
}
-- Your launch.json uses "type": "node"; point it at the same adapter.
dap.adapters.node = dap.adapters['pwa-node']

-- Make node / pwa-node launch.json configs available in JS/TS buffers.
local vscode = require 'dap.ext.vscode'
vscode.type_to_filetypes['node'] = { 'javascript', 'typescript' }
vscode.type_to_filetypes['pwa-node'] = { 'javascript', 'typescript' }

-- Safety-net config, used only if a project has no .vscode/launch.json.
for _, ft in ipairs { 'javascript', 'typescript' } do
  dap.configurations[ft] = dap.configurations[ft] or {}
  table.insert(dap.configurations[ft], {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach to port 9229 (node --inspect)',
    address = 'localhost',
    port = 9229,
    cwd = '${workspaceFolder}',
    restart = true,
    skipFiles = { '<node_internals>/**' },
  })
end
