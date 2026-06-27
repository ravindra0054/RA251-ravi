# ScandiPWA Compilation Error Fix Guide

## Error Analysis
```
Class "Magento\CatalogGraphQl\Model\Resolver\Products\DataProvider\ProductSearch\ProductCollectionSearchCriteriaBuilder" not found
```

This error occurs because ScandiPWA's `catalog-graphql` module is trying to extend a Magento class that doesn't exist in your Magento version.

## Root Causes
1. **Version Mismatch**: ScandiPWA catalog-graphql version incompatible with Magento 2.4.8-p1
2. **Missing Core Module**: Magento's CatalogGraphQl module missing or outdated
3. **Class Relocation**: Magento moved/renamed the class in newer versions

## Quick Fix Steps

### Step 1: Clear Generated Files
```bash
rm -rf generated/code/* generated/metadata/* var/cache/*
```

### Step 2: Fix ScandiPWA Version Compatibility
```bash
# Downgrade problematic ScandiPWA modules
composer require scandipwa/catalog-graphql:^5.2.0 --no-update
composer require scandipwa/core-scandipwa:^6.2.0 --no-update

# Update dependencies
composer update scandipwa/catalog-graphql scandipwa/core-scandipwa
```

### Step 3: Ensure Magento GraphQL Modules
```bash
# Install/update required Magento modules
composer require magento/module-catalog-graph-ql:* --no-update
composer require magento/module-graph-ql:* --no-update
composer update magento/module-catalog-graph-ql magento/module-graph-ql
```

### Step 4: Run Magento Setup
```bash
php bin/magento setup:upgrade
php bin/magento module:enable --all
```

### Step 5: Try Compilation Again
```bash
php -d memory_limit=2G bin/magento setup:di:compile
```

## Alternative Solutions

### Solution A: Use Compatible ScandiPWA Version Matrix

For **Magento 2.4.8-p1**, use these ScandiPWA versions:

```json
{
    "require": {
        "scandipwa/catalog-graphql": "^5.2.0",
        "scandipwa/core-scandipwa": "^6.2.0",
        "scandipwa/customer-graph-ql": "^4.1.0",
        "scandipwa/framework": "^4.0.0",
        "scandipwa/graphql-core": "^2.0.0",
        "scandipwa/quote-graphql": "^3.1.0"
    }
}
```

### Solution B: Patch the Problematic File

If the class truly doesn't exist, create a compatibility patch:

1. **Check if the class exists in a different location:**
```bash
find vendor/magento -name "*.php" -exec grep -l "ProductCollectionSearchCriteriaBuilder" {} \;
```

2. **Create a compatibility class** (if needed):
```php
<?php
// File: app/code/Compatibility/CatalogGraphQl/Model/Resolver/Products/DataProvider/ProductSearch/ProductCollectionSearchCriteriaBuilder.php

namespace Magento\CatalogGraphQl\Model\Resolver\Products\DataProvider\ProductSearch;

class ProductCollectionSearchCriteriaBuilder
{
    // Minimal implementation for compatibility
    public function build(array $args, bool $includeAggregation): array
    {
        return [];
    }
}
```

### Solution C: Downgrade to Stable Magento Version

If issues persist, consider using a more stable combination:

```bash
# Use Magento 2.4.6 with ScandiPWA 6.2.x
composer require magento/product-community-edition:2.4.6 --no-update
composer require scandipwa/core-scandipwa:^6.2.0 --no-update
composer update
```

## Verification Steps

### 1. Check Module Status
```bash
php bin/magento module:status | grep -E "(Catalog|GraphQl|ScandiPWA)"
```

### 2. Verify Class Existence
```bash
# Check if the problematic class now exists
find vendor/magento -name "*ProductCollectionSearchCriteriaBuilder*" -type f
```

### 3. Test GraphQL Endpoint
```bash
curl -X POST http://your-domain/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ products(search: \"test\") { items { name } } }"}'
```

## Troubleshooting Common Issues

### Issue 1: Memory Limit Errors
```bash
php -d memory_limit=4G bin/magento setup:di:compile
```

### Issue 2: Permission Errors
```bash
sudo chown -R www-data:www-data generated/ var/
sudo chmod -R 755 generated/ var/
```

### Issue 3: Autoloader Issues
```bash
composer dump-autoload -o
```

## Prevention for Future Updates

1. **Always check compatibility matrix** before updating
2. **Use version constraints** in composer.json:
   ```json
   "scandipwa/catalog-graphql": "~5.2.0"
   ```
3. **Test in staging environment** first
4. **Keep backups** of working composer.lock files

## Emergency Rollback

If all else fails, rollback to working state:

```bash
# Restore from backup
cp composer.lock.backup composer.lock
cp composer.json.backup composer.json

# Reinstall dependencies
rm -rf vendor/
composer install

# Clear and recompile
rm -rf generated/* var/cache/*
php bin/magento setup:upgrade
php bin/magento setup:di:compile
```

## Support Resources

- **ScandiPWA GitHub Issues**: https://github.com/scandipwa/scandipwa/issues
- **Magento Community**: https://community.magento.com/
- **ScandiPWA Slack**: https://scandipwa.slack.com/

---

**Note**: This error is typically a version compatibility issue. The recommended approach is to use the correct ScandiPWA version for your Magento installation rather than trying to patch missing classes.