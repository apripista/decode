#!/bin/bash

# Function to decode from Base64
decode_base64() {
    if command -v base64 &> /dev/null; then
        echo -n "$1" | base64 -d
    else
        echo "Base64 decoding tool not found."
    fi
}

# Function to decode from Base32
decode_base32() {
    if command -v base32 &> /dev/null; then
        echo -n "$1" | base32 -d
    else
        echo "Base32 decoding tool not found."
    fi
}

# Function to decode from Base16 (Hexadecimal)
decode_base16() {
    if command -v xxd &> /dev/null; then
        echo -n "$1" | xxd -r -p
    else
        echo "Hexadecimal decoding tool not found."
    fi
}

# Function to decode HTML entities
decode_html() {
    echo "$1" | sed 's/&lt;/</g; s/&gt;/>/g; s/&amp;/&/g; s/&quot;/"/g; s/&#39;/'\''/g'
}

# Function to decode URL-encoded strings
decode_url() {
    echo "$1" | sed 's/%20/ /g; s/%21/!/g; s/%23/#/g; s/%24/$/g; s/%25/%/g; s/%26/&/g; s/%27/'\''/g; s/%28/(/g; s/%29/)/g; s/%2A/*/g; s/%2B/+/g; s/%2C/,/g; s/%2D/-/g; s/%2E/./g; s/%2F/\//g; s/%3A/:/g; s/%3B/;/g; s/%3C/</g; s/%3D/=</g; s/%3E/>/g; s/%3F/?/g; s/%40/@/g; s/%5B/[//g; s/%5C/\\//g; s/%5D/]/g; s/%5E/^/g; s/%5F/_/g; s/%60/`/g; s/%7B/{/g; s/%7C/|/g; s/%7D/}/g; s/%7E/~/g'
}

# Function to detect encoding type
detect_encoding() {
    if echo "$1" | grep -qE '^[0-9A-Fa-f]+$'; then
        echo "The string appears to be Base16 (Hexadecimal)."
    elif echo "$1" | grep -qE '^[A-Z2-7=]+$'; then
        echo "The string appears to be Base32."
    elif echo "$1" | grep -qE '^[A-Za-z0-9+/=]+$'; then
        echo "The string appears to be Base64."
    elif echo "$1" | grep -qE '^[01 ]+$'; then
        echo "The string appears to be Binary encoded."
    elif echo "$1" | grep -qE '^[0-7 ]+$'; then
        echo "The string appears to be Octal encoded."
    else
        echo "Unable to detect encoding type."
    fi
}

# Function to display base decoding options
base_decoding_options() {
    echo "Base decoding options:"
    echo "1. Base64"
    echo "2. Base32"
    echo "3. Base16 (Hexadecimal)"
    read -p "Enter the number corresponding to your choice: " base_choice

    case $base_choice in
        1)
            decoded=$(decode_base64 "$input_string")
            ;;
        2)
            decoded=$(decode_base32 "$input_string")
            ;;
        3)
            decoded=$(decode_base16 "$input_string")
            ;;
        *)
            echo "Invalid choice"
            return
            ;;
    esac

    if [ -z "$decoded" ]; then
        echo "Decoding failed or tool not available."
    else
        echo "Decoded string: $decoded"
    fi
}

# Function to display HTML decoding options
html_decoding_options() {
    echo "Decoding HTML entities..."
    decoded=$(decode_html "$input_string")
    if [ -z "$decoded" ]; then
        echo "Decoding failed."
    else
        echo "Decoded string: $decoded"
    fi
}

# Function to display URL decoding options
url_decoding_options() {
    echo "Decoding URL encoding..."
    decoded=$(decode_url "$input_string")
    if [ -z "$decoded" ]; then
        echo "Decoding failed."
    else
        echo "Decoded string: $decoded"
    fi
}

# Display logging message and main menu
echo "InsipiraHub: Starting the decoding tool..."
echo ""
echo "Choose a category for decoding:"
echo "A. Base decoding"
echo "B. HTML decoding"
echo "C. URL decoding"
read -p "Enter your choice (A, B, C): " category_choice

# Convert category_choice to uppercase
category_choice=$(echo "$category_choice" | tr '[:lower:]' '[:upper:]')

# Get the string to decode
read -p "Enter the string to decode: " input_string

# Process category choice and call appropriate function
case $category_choice in
    A)
        detect_encoding "$input_string"
        base_decoding_options
        ;;
    B)
        html_decoding_options
        ;;
    C)
        url_decoding_options
        ;;
    *)
        echo "Invalid category choice"
        ;;
esac
