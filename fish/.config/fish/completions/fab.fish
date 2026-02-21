# Fish shell completions for 'fab' (alias for fabric-ai)
# Mirrors /opt/homebrew/share/fish/vendor_completions.d/fabric-ai.fish

function __fab_get_patterns
    fab --listpatterns --shell-complete-list 2>/dev/null
end

function __fab_get_models
    fab --listmodels --shell-complete-list 2>/dev/null
end

function __fab_get_vendors
    fab --listvendors --shell-complete-list 2>/dev/null
end

function __fab_get_contexts
    fab --listcontexts --shell-complete-list 2>/dev/null
end

function __fab_get_sessions
    fab --listsessions --shell-complete-list 2>/dev/null
end

function __fab_get_strategies
    fab --liststrategies --shell-complete-list 2>/dev/null
end

function __fab_get_extensions
    fab --listextensions --shell-complete-list 2>/dev/null
end

function __fab_get_gemini_voices
    fab --list-gemini-voices --shell-complete-list 2>/dev/null
end

function __fab_get_transcription_models
    fab --list-transcription-models --shell-complete-list 2>/dev/null
end

complete -c fab -f

# Flags with arguments
complete -c fab -s p -l pattern              -d "Choose a pattern"                              -a "(__fab_get_patterns)"
complete -c fab -s v -l variable             -d "Pattern variable values, e.g. -v=#role:expert"
complete -c fab -s C -l context              -d "Choose a context"                              -a "(__fab_get_contexts)"
complete -c fab      -l session              -d "Choose a session"                              -a "(__fab_get_sessions)"
complete -c fab -s a -l attachment           -d "Attachment path or URL"                        -r
complete -c fab -s t -l temperature          -d "Set temperature (default: 0.7)"
complete -c fab -s T -l topp                 -d "Set top P (default: 0.9)"
complete -c fab -s P -l presencepenalty      -d "Set presence penalty (default: 0.0)"
complete -c fab -s F -l frequencypenalty     -d "Set frequency penalty (default: 0.0)"
complete -c fab -s m -l model                -d "Choose model"                                  -a "(__fab_get_models)"
complete -c fab -s V -l vendor               -d "Specify vendor for chosen model"               -a "(__fab_get_vendors)"
complete -c fab      -l modelContextLength   -d "Model context length (ollama only)"
complete -c fab -s o -l output               -d "Output to file"                                -r
complete -c fab -s n -l latest               -d "Number of latest patterns to list"
complete -c fab -s y -l youtube              -d "YouTube URL to grab transcript/comments"
complete -c fab -s g -l language             -d "Language code, e.g. -g=en -g=zh"
complete -c fab -s u -l scrape_url           -d "Scrape URL to markdown via Jina AI"
complete -c fab -s q -l scrape_question      -d "Search question via Jina AI"
complete -c fab -s e -l seed                 -d "Seed for LLM generation"
complete -c fab      -l thinking             -d "Reasoning level"                               -a "off low medium high"
complete -c fab -s w -l wipecontext          -d "Wipe context"                                  -a "(__fab_get_contexts)"
complete -c fab -s W -l wipesession          -d "Wipe session"                                  -a "(__fab_get_sessions)"
complete -c fab      -l printcontext         -d "Print context"                                 -a "(__fab_get_contexts)"
complete -c fab      -l printsession         -d "Print session"                                 -a "(__fab_get_sessions)"
complete -c fab      -l address              -d "REST API bind address (default: :8080)"
complete -c fab      -l api-key              -d "API key for server routes"
complete -c fab      -l config               -d "Path to YAML config file"                      -r -a "*.yaml *.yml"
complete -c fab      -l search-location      -d "Location for web search (e.g. America/Los_Angeles)"
complete -c fab      -l image-file           -d "Save generated image to file"                  -r -a "*.png *.webp *.jpeg *.jpg"
complete -c fab      -l image-size           -d "Image dimensions"                              -a "1024x1024 1536x1024 1024x1536 auto"
complete -c fab      -l image-quality        -d "Image quality"                                 -a "low medium high auto"
complete -c fab      -l image-compression    -d "Compression level 0-100 (JPEG/WebP)"           -r
complete -c fab      -l image-background     -d "Background type"                               -a "opaque transparent"
complete -c fab      -l addextension         -d "Register extension from config file"           -r -a "*.yaml *.yml"
complete -c fab      -l rmextension          -d "Remove registered extension"                   -a "(__fab_get_extensions)"
complete -c fab      -l strategy             -d "Choose a strategy"                             -a "(__fab_get_strategies)"
complete -c fab      -l think-start-tag      -d "Start tag for thinking sections"
complete -c fab      -l think-end-tag        -d "End tag for thinking sections"
complete -c fab      -l voice                -d "TTS voice name"                                -a "(__fab_get_gemini_voices)"
complete -c fab      -l transcribe-file      -d "Audio/video file to transcribe"               -r -a "*.mp3 *.mp4 *.mpeg *.mpga *.m4a *.wav *.webm"
complete -c fab      -l transcribe-model     -d "Model for transcription"                       -a "(__fab_get_transcription_models)"
complete -c fab      -l debug                -d "Debug level (0=off, 1=basic, 2=detailed, 3=trace)" -a "0 1 2 3"
complete -c fab      -l notification-command -d "Custom notification command"
complete -c fab -s w -l wipecontext          -d "Wipe context"                                  -a "(__fab_get_contexts)"
complete -c fab      -l yt-dlp-args          -d "Additional yt-dlp arguments"

# Boolean flags
complete -c fab -s S -l setup                    -d "Run setup for all reconfigurable parts"
complete -c fab -s s -l stream                   -d "Stream output"
complete -c fab -s r -l raw                      -d "Use model defaults without chat options"
complete -c fab -s l -l listpatterns             -d "List all patterns"
complete -c fab -s L -l listmodels               -d "List all available models"
complete -c fab -s x -l listcontexts             -d "List all contexts"
complete -c fab -s X -l listsessions             -d "List all sessions"
complete -c fab -s U -l updatepatterns           -d "Update patterns"
complete -c fab -s c -l copy                     -d "Copy to clipboard"
complete -c fab      -l output-session           -d "Output entire session to output file"
complete -c fab -s d -l changeDefaultModel       -d "Change default model"
complete -c fab      -l playlist                 -d "Prefer playlist over video in URL"
complete -c fab      -l transcript               -d "Grab YouTube transcript and send to chat"
complete -c fab      -l transcript-with-timestamps -d "Grab YouTube transcript with timestamps"
complete -c fab      -l comments                 -d "Grab YouTube comments and send to chat"
complete -c fab      -l metadata                 -d "Output video metadata"
complete -c fab      -l readability              -d "Convert HTML to clean readable view"
complete -c fab      -l input-has-vars           -d "Apply variables to user input"
complete -c fab      -l no-variable-replacement  -d "Disable pattern variable replacement"
complete -c fab      -l dry-run                  -d "Show what would be sent without sending"
complete -c fab      -l search                   -d "Enable web search for supported models"
complete -c fab      -l serve                    -d "Serve the Fabric REST API"
complete -c fab      -l serveOllama              -d "Serve the Fabric REST API with Ollama endpoints"
complete -c fab      -l version                  -d "Print current version"
complete -c fab      -l listextensions           -d "List all registered extensions"
complete -c fab      -l liststrategies           -d "List all strategies"
complete -c fab      -l listvendors              -d "List all vendors"
complete -c fab      -l list-gemini-voices       -d "List all Gemini TTS voices"
complete -c fab      -l shell-complete-list      -d "Output raw list for shell completion"
complete -c fab      -l suppress-think           -d "Suppress text in thinking tags"
complete -c fab      -l disable-responses-api    -d "Disable OpenAI Responses API"
complete -c fab      -l split-media-file         -d "Split audio/video files >25MB via ffmpeg"
complete -c fab      -l notification             -d "Send desktop notification on complete"
complete -c fab      -l spotify                  -d "Spotify podcast/episode URL for metadata"
complete -c fab -s h -l help                     -d "Show help message"
