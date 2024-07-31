#!/bin/bash

# print a letter in dot-based pattern
print_letter() {
    local letter="$1"

    case $letter in
        a) echo -e "  *  \n * * \n*****\n*   *\n*   *" ;;
        b) echo -e "**** \n*   *\n**** \n*   *\n**** " ;;
        c) echo -e " *** \n*   \n*   \n*   \n ***" ;;
        d) echo -e "**** \n*   *\n*   *\n*   *\n**** " ;;
        e) echo -e "*****\n*    \n**** \n*    \n*****" ;;
        f) echo -e "*****\n*    \n**** \n*    \n*    " ;;
        g) echo -e " *** \n*   \n*  **\n*   *\n *** " ;;
        h) echo -e "*   *\n*   *\n*****\n*   *\n*   *" ;;
        i) echo -e " *** \n  *  \n  *  \n  *  \n *** " ;;
        j) echo -e "  ***\n   * \n   * \n*  * \n **  " ;;
        k) echo -e "*  * \n* *  \n**   \n* *  \n*  * " ;;
        l) echo -e "*    \n*    \n*    \n*    \n*****" ;;
        m) echo -e "*   *\n** **\n* * *\n*   *\n*   *" ;;
        n) echo -e "*   *\n**  *\n* * *\n*  **\n*   *" ;;
        o) echo -e " *** \n*   *\n*   *\n*   *\n *** " ;;
        p) echo -e "**** \n*   *\n**** \n*    \n*    " ;;
        q) echo -e " *** \n*   *\n*   *\n*  **\n *** \n *" ;;
        r) echo -e "**** \n*   *\n**** \n* *  \n*  * " ;;
        s) echo -e " *** \n*    \n *** \n    *\n *** " ;;
        t) echo -e "*****\n  *  \n  *  \n  *  \n  *  " ;;
        u) echo -e "*   *\n*   *\n*   *\n*   *\n *** " ;;
        v) echo -e "*   *\n*   *\n * * \n * * \n  *  " ;;
        w) echo -e "*   *\n*   *\n* * *\n* * *\n * * " ;;
        x) echo -e "*   *\n * * \n  *  \n * * \n*   *" ;;
        y) echo -e "*   *\n * * \n  *  \n  *  \n  *  " ;;
        z) echo -e "*****\n   * \n  *  \n *   \n*****" ;;
        *) echo "Unknown letter" ;;
    esac
}

# print a word in dot-based pattern
print_dotted_word() {
    local word="$1"
    local i

    for i in $(seq 1 5); do
        for (( j=0; j<${#word}; j++ )); do
            letter="${word:$j:1}"
	    # Convert to lowercase for patterns
            letter=$(echo "$letter" | tr '[:upper:]' '[:lower:]')
            print_letter "$letter" | sed -n "${i}p" | tr '\n' ' '
        done
        echo
    done
}

# decode from Base64
decode_base64() {
    if command -v base64 &> /dev/null; then
        echo -n "$1" | base64 -d
    else
        echo "Base64 decoding tool not found."
    fi
}

# decode from Base32
decode_base32() {
    if command -v base32 &> /dev/null; then
        echo -n "$1" | base32 -d
    else
        echo "Base32 decoding tool not found."
    fi
}

# decode from Base16 (Hexadecimal)
decode_base16() {
    if command -v xxd &> /dev/null; then
        echo -n "$1" | xxd -r -p
    else
        echo "Hexadecimal decoding tool not found."
    fi
}

# decode HTML entities
decode_html() {
    echo "$1" | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&#39;/'\''/g'
}

# decode URL-encoded strings
decode_url() {
    echo "$1" | python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.stdin.read().strip()))"
}

# decode Binary encoded strings
decode_binary() {
    binary_string=$(echo "$1" | tr -d ' ')
    length=${#binary_string}
    decoded_string=""

    for ((i=0; i<length; i+=8)); do
        byte=${binary_string:i:8}
        decimal=$((2#$byte))
        decoded_string+=$(printf "\\x%x" "$decimal")
    done

    echo -e "$decoded_string"
}

# decode Octal encoded strings
decode_octal() {
    echo "$1" | awk '{for(i=1;i<=NF;i++)printf("%c",strtonum("0"$i));print""}'
}

# detect encoding type
detect_encoding() {
    if echo "$1" | grep -qE '^[0-9A-Fa-f]+$'; then
        echo "The string appears to be Base16 (Hexadecimal)."
        return 1
    elif echo "$1" | grep -qE '^[A-Z2-7=]+$'; then
        echo "The string appears to be Base32."
        return 2
    elif echo "$1" | grep -qE '^[A-Za-z0-9+/=]+$'; then
        echo "The string appears to be Base64."
        return 3
    elif echo "$1" | grep -qE '(&amp;|&lt;|&gt;|&quot;|&#39;)'; then
        echo "The string appears to be HTML encoded."
        return 4
    elif echo "$1" | grep -qE '(%[0-9A-Fa-f]{2})+'; then
        echo "The string appears to be URL encoded."
        return 5
    elif echo "$1" | grep -qE '^[01 ]+$'; then
        echo "The string appears to be Binary encoded."
        return 6
    elif echo "$1" | grep -qE '^[0-7 ]+$'; then
        echo "The string appears to be Octal encoded."
        return 7
    else
        echo "Unable to detect encoding type."
        return 0
    fi
}

# Clear screen
clear

# Display the log message
echo "InsipiraHub - displaying word in dot-based pattern:"

# Add an empty line before the word
echo

# Print the word in dot-based pattern
print_dotted_word "InsipiraHub"

echo

# Get the string to decode
read -p "Enter the string to decode: " input_string

# Detect the encoding type
detect_encoding "$input_string"
encoding_type=$?

# Display debugging information
echo "Detected encoding type: $encoding_type"

# you want to decode? yes/no
if [ $encoding_type -ne 0 ]; then
    read -p "Do you want to decode it? (yes/no) " decode_choice
    if [ "$decode_choice" == "yes" ]; then
        case $encoding_type in
            1)
                decoded=$(decode_base16 "$input_string");;
            2)
                decoded=$(decode_base32 "$input_string");;
            3)
                decoded=$(decode_base64 "$input_string");;
            4)
                decoded=$(decode_html "$input_string");;
            5)
                decoded=$(decode_url "$input_string");;
            6)
                decoded=$(decode_binary "$input_string");;
            7)
                decoded=$(decode_octal "$input_string");;
            *)
                echo "Invalid encoding type detected."
                exit 1;;
        esac

        if [ -z "$decoded" ]; then
            echo "Decoding failed or tool not available."
        else
            echo "Decoded string: $decoded"
        fi
    else
        echo "Decoding aborted."
    fi
else
    echo "Unable to detect encoding type or input string is empty."
fi
