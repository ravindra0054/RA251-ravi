#!/bin/bash

echo "Magento 2 Composer Setup Helper"
echo "================================"

# Function to create minimal lockfile
create_minimal_lockfile() {
    echo "Creating minimal composer.lock file..."
    cp composer.json composer-full.json.bak
    cp composer-minimal.json composer.json
    composer install --no-interaction
    cp composer.json composer-minimal.json.bak
    cp composer-full.json.bak composer.json
    echo "✅ Minimal composer.lock created. You can now add Magento dependencies."
}

# Function to setup Magento authentication
setup_magento_auth() {
    echo "Setting up Magento authentication..."
    echo "Please enter your Magento Marketplace credentials:"
    read -p "Public Key: " public_key
    read -s -p "Private Key: " private_key
    echo ""
    
    composer config --auth http-basic.repo.magento.com "$public_key" "$private_key"
    echo "✅ Magento authentication configured."
}

# Function to install full dependencies
install_full_dependencies() {
    echo "Installing full Magento dependencies..."
    composer install --no-interaction
    if [ $? -eq 0 ]; then
        echo "✅ All dependencies installed successfully!"
    else
        echo "❌ Installation failed. Check your Magento authentication keys."
    fi
}

# Main menu
echo ""
echo "Choose an option:"
echo "1. Create minimal lockfile (without Magento packages)"
echo "2. Setup Magento authentication"
echo "3. Install full dependencies"
echo "4. Do all steps (1, 2, 3)"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        create_minimal_lockfile
        ;;
    2)
        setup_magento_auth
        ;;
    3)
        install_full_dependencies
        ;;
    4)
        create_minimal_lockfile
        echo ""
        setup_magento_auth
        echo ""
        install_full_dependencies
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        ;;
esac

echo ""
echo "Setup complete! Check README_MAGENTO_SETUP.md for more details."