#!/bin/bash

echo "🔧 ScandiPWA Compatibility Fix Script"
echo "====================================="

# Check Magento version
echo "📋 Checking Magento version..."
MAGENTO_VERSION=$(php bin/magento --version 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
echo "Magento Version: $MAGENTO_VERSION"

# Check if the problematic class exists
echo "🔍 Checking for missing class..."
if find vendor/magento -name "*ProductCollectionSearchCriteriaBuilder*" -type f | grep -q .; then
    echo "✅ Class found in Magento core"
else
    echo "❌ Class NOT found - This is the source of the error"
fi

echo ""
echo "🛠️  Applying fixes..."

# Fix 1: Downgrade ScandiPWA catalog-graphql to compatible version
echo "1. Downgrading ScandiPWA catalog-graphql..."
composer require scandipwa/catalog-graphql:^5.2 --no-update

# Fix 2: Update other ScandiPWA modules to compatible versions
echo "2. Updating ScandiPWA modules to compatible versions..."
composer require scandipwa/core-scandipwa:^6.2.0 --no-update
composer require scandipwa/customer-graph-ql:^4.1 --no-update
composer require scandipwa/quote-graphql:^3.1 --no-update

# Fix 3: Ensure Magento GraphQL modules are installed
echo "3. Ensuring Magento GraphQL modules are present..."
composer require magento/module-catalog-graph-ql --no-update
composer require magento/module-graph-ql --no-update

# Update all dependencies
echo "4. Updating dependencies..."
composer update scandipwa/* magento/module-catalog-graph-ql magento/module-graph-ql

echo ""
echo "✅ Compatibility fixes applied!"
echo "🔄 Now run: php bin/magento setup:upgrade"