require('avante').setup {
    -- Use the gemini provider
    provider = 'gemini',
    providers = {
        gemini = {
            api_key_name = { 'cat', '~/.config/ai-keys/gemini' },
            model = 'gemini-2.5-flash-preview-05-20',
        },
        gemini_pro = {
            __inherited_from = "gemini",
            model = 'gemini-2.5-pro-preview-05-06',
        },
        openai = {
            api_key_name = { 'cat', '~/.config/ai-keys/openai' },
        },
    },
    mappings = {
        sidebar = {
            edit_user_request = 'u',
        },
    },
    rag_service = {
        enabled = true,
        host_mount = os.getenv("HOME"), -- Or the appropriate path
        provider = "ollama",
        llm_model = "gemma3:4b",
        embed_model = "nomic-embed-text",
        endpoint = "http://localhost:11434",
        runner = "nix",
    },
    web_search_engine = {
        provider = 'google',
    },
}
