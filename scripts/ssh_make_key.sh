#!/usr/bin/env bash

set -e

readonly KEY_NAME="$1"
readonly KEY_PASSWORD="$2"
readonly KEY_DIR="./keys"
readonly PRIVATE_KEY="$KEY_DIR/$KEY_NAME"
readonly PUBLIC_KEY="$KEY_DIR/$KEY_NAME.pub"

if [ -z "$KEY_NAME" ]; then
    echo "Usage: $0 <key-name> <password>"
    exit 1
fi


if [ -f "$PRIVATE_KEY" ] || [ -f "$PUBLIC_KEY" ]; then
    echo "Key '$KEY_NAME' already exists in $KEY_DIR"
    exit 0
fi

ssh-keygen \
    -t ed25519 \
    -f "$PRIVATE_KEY" \
    -N "$KEY_PASSWORD" \
    -C "$KEY_NAME"

echo "Keypair generated:"
echo "Private key: $PRIVATE_KEY"
echo "Public key : $PUBLIC_KEY"