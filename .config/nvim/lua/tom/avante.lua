require('avante').setup {
    -- Use the gemini_pro provider
    provider = 'gemini_pro',
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
    },
    behaviour = {
        enable_token_counting = false,
        auto_approve_tool_permissions = true,
    },
    mappings = {
        sidebar = {
            edit_user_request = 'u',
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
            embed_model = "nomic-embed-text",
        },
        runner = "nix",
    },
    web_search_engine = {
        provider = 'google',
    },
}
