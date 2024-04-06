#!/usr/bin/env bash

# Function to validate input
validate_input() {
    input="$1"

    # Check if input is in lowercase
    if [[ "$input" != "${input,,}" ]]; then
        echo "Error: Input must be in lowercase."
        return 1
    fi

    # Check if input is in snake_case format
    if [[ "$input" =~ ^[a-z]+(_[a-z]+)*$ ]]; then
        echo "Input is in valid snake_case format."
    else
        echo "Error: Input must be in snake_case format."
        return 1
    fi
}

# Function to set gem variables
set_gem_variables() {
    input="$1"

    # Set GEM_NAME
    GEM_NAME="$input"

    # Convert snake_case to camelCase for CAMEL_CASED_NAME
    IFS="_" read -ra words <<< "$input"
    camel_case=""
    for word in "${words[@]}"; do
        camel_case+="${word^}"
    done
    CAMEL_CASED_NAME="$camel_case"
}
