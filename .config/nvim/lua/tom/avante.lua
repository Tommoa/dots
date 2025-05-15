require('avante').setup {
    -- Use the gemini provider
    provider = 'gemini',
    gemini = {
        -- For some reason this doesn't seem to work with relative paths?
        api_key_name = { 'bash', '-c', 'cat ~/.config/ai-keys/gemini' },
        model = 'gemini-2.5-flash-preview-04-17',
    },
    vendors = {
       gemini_pro = {
           __inherited_from = "gemini",
           model = 'gemini-2.5-pro-preview-05-06',
       }
    },
    openai = {
        api_key_name = { 'bash', '-c', 'cat ~/.config/ai-keys/openai' },
    },
    mappings = {
        sidebar = {
            edit_user_request = 'u',
        },
    },
    rag_service = {
        enabled = true,
        host_mount = os.getenv("HOME"), -- Or the appropriate path
        -- provider = "openai",
        -- llm_model = "gpt-4-turbo", -- Or "gpt-4-turbo", "gpt-3.5-turbo"
        -- embed_model = "text-embedding-3-small", -- Or "text-embedding-3-small"
        -- endpoint = "https://api.openai.com/v1", -- Standard OpenAI API endpoint
        runner = "nix",
    },
    web_search_engine = {
        provider = 'google',
    },
}
