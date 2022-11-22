local path = require("null-ls.utils").path
local memoize = require("plenary.memoize").memoize

local fs = vim.fs
local validate = vim.validate

local EXTRA_FOLDER = path.join(vim.fn.stdpath("config"), "extra/null-ls/")

-- TODO: Control how the cache gets clean up with `on_attach` and `on_exit`.
local gca_cache = {}

return {
    ---Get the default config file for an expecified `config-name`.
    ---@param config_name string
    ---@return string
    get_default_config = function(config_name)
        validate({ config_name = { config_name, "string" } })
        return path.join(EXTRA_FOLDER, config_name)
    end,
    ---Returns a function getting a `params` null-ls object to generate/find the configuration needed for the `params.root` directory.
    ---@param config_flag string config flag of the source (e.g "--config-path")
    ---@param file_patterns string|table pattern(s) to find the configuration
    ---@param fallback string|table|fun(s: string): string if string the full path of the configuration, if table the list of arguments to use, and if a function it will take the first entry of `file-patterns`, and will return a full path for it ( can use it if a default the first file_patterns is the name of the default file, but it is just in another place. )
    ---@return fun(params: table): table
    get_config_args = function(config_flag, file_patterns, fallback, opts)
        opts = opts or {}

        validate({
            config_flag = { config_flag, "string" },
            file_patterns = { file_patterns, { "string", "table" } },
            fallback = { fallback, { "string", "table", "function" } },
            extra_args = { opts.extra_args, "table", true },
        })

        file_patterns = type(file_patterns) == "string" and { file_patterns } or file_patterns
        local extra_args = opts.extra_args or {}

        local get_config_args = function(root)
            local config_file = fs.find(file_patterns, { path = root, type = "file" })[1]
            local config = config_file and { config_flag, config_file }

            if not config then
                local s = fallback
                local t = type(fallback)

                if t == "function" then
                    s = fallback(file_patterns[1])
                end

                config = t == "table" and fallback or { config_flag, s }
            end

            return vim.list_extend(extra_args, config)
        end

        return function(params)
            -- FIX: After so many hours trying to understand why each time I called the function it
            -- appended a '-' to the end, `null-ls` doesn't take into account functions that return
            -- cached tables.
            return vim.deepcopy(memoize(function(root)
                return get_config_args(root)
                -- NOTE: I don't need `command` and `method` for `get_config_args` to work. I'm
                -- using them as a cache key combined with `root`.
            end, gca_cache)(params.root, params.command, params.method))
        end
    end,
}
