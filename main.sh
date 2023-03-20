
#!/bin/bash
# -------------------------------------
# Made with perfection by @Bassemer.
# Forked from @CristiVlad25
# 2023
# -------------------------------------

set -euo pipefail

# Constants
readonly API_KEY="-"
readonly MODEL="text-davinci-003"
readonly TOKEN_COUNT=300

# Input validation
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <prompt>"
    exit 1
fi

# Payload file
readonly PAYLOAD_FILE=$(mktemp)
cat << EOF > "$PAYLOAD_FILE"
{
    "model": "$MODEL",
    "prompt": "$1",
    "temperature": 0.4,
    "top_p": 1,
    "frequency_penalty": 0.5,
    "presence_penalty": 0.5,
    "max_tokens": $TOKEN_COUNT
}
EOF

# API call
response=$(curl -sS --fail \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d "@$PAYLOAD_FILE" \
    https://api.openai.com/v1/completions)

# Extract output
output=$(echo "$response" | jq -r '.choices[0].text')

# Clean up
rm "$PAYLOAD_FILE"

# Print output
echo "$output"
