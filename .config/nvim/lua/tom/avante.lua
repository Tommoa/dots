local mcp_tools = require("mcphub.extensions.avante").mcp_tool()

require('avante').setup {
    -- Use the gemini_pro provider
    provider = 'gemini_pro',
    auto_suggestions_provider = 'gemini',
    providers = {
        gemini = {
            api_key_name = { 'cat', '~/.config/ai-keys/gemini' },
            model = 'gemini-2.5-flash',
        },
        gemini_pro = {
            __inherited_from = "gemini",
            model = 'gemini-2.5-pro',
        },
        openai = {
            api_key_name = { 'cat', '~/.config/ai-keys/openai' },
        },
        ollama = {
            model = 'gemini3:4b',
        },
    },
    behaviour = {
        enable_token_counting = false,
        auto_approve_tool_permissions = true,
        auto_suggestions = true,
    },
    mappings = {
        sidebar = {
            edit_user_request = 'u',
        },
        suggestion = {
            accept = "<M-j>",
            next = "<C-u>",
            prev = "<C-l>",
        },
    },
    rag_service = {
        enabled = true,
        llm = {
            provider = "ollama",
            endpoint = "http://localhost:11434",
            api_key = "",
            model = "gemma3:4b",
        },
        embed = {
            provider = "ollama",
            endpoint = "http://localhost:11434",
            api_key = "",
            model = "nomic-embed-text",
        },
        runner = "nix",
    },
    web_search_engine = {
        provider = 'google',
    },
    -- Enable MCP as the system prompt if it exists.
    system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
    end,
    custom_tools = function()
        local custom_tools_path = vim.fn.expand("~/.config/custom_tools.lua")
        if vim.fn.filereadable(custom_tools_path) == 0 then
            -- This is not an error, as there may not be custom tools.
            return mcp_tools
        end
        local ok, result = pcall(dofile, custom_tools_path)
        if not ok then
            vim.notify("Failed to load custom tools from " .. custom_tools_path .. ": " .. result, vim.log.levels.ERROR)
            return mcp_tools
        end
        if type(result) ~= "table" then
            vim.notify("Custom tools file " .. custom_tools_path .. " did not return a table.", vim.log.levels.ERROR)
            return mcp_tools
        end
        return vim.tbl_deep_extend('keep', mcp_tools, result)
    end,
}
