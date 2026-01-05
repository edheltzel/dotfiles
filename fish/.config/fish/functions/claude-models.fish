function claude-models --description 'List latest Claude models (opus, sonnet, haiku)'
    curl -s "https://api.anthropic.com/v1/models?limit=100" \
        -H "anthropic-version: 2023-06-01" \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
    | jq -r '
        .data
        | map(select(.id | test("opus|sonnet|haiku")))
        | group_by(.id | capture("(?<family>opus|sonnet|haiku)").family)
        | map(.[0:3])
        | flatten
        | .[]
        | "\(.id)\t\(.display_name)"
    '
end
