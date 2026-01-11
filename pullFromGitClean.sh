#!/bin/bash

echo "🔄 Pulling latest changes from Git..."
git pull || { echo "❌ Git pull failed"; exit 1; }

echo "🧹 Clearing caches before build..."
php artisan optimize:clear || { echo "❌ Failed to clear caches"; exit 1; }
php artisan config:clear || { echo "❌ Failed to clear config cache"; exit 1; }
php artisan route:clear || { echo "❌ Failed to clear route cache"; exit 1; }
php artisan view:clear || { echo "❌ Failed to clear view cache"; exit 1; }

echo "📦 Installing PHP dependencies..."
composer install --no-dev --optimize-autoloader || { echo "❌ Composer install failed"; exit 1; }

echo "📦 Installing NPM packages..."
npm install || { echo "❌ NPM install failed"; exit 1; }

echo "⚙️ Building frontend assets..."
npm run build || { echo "❌ NPM build failed"; exit 1; }

echo "🧱 Running database migrations..."
php artisan migrate --force || { echo "❌ Artisan migrate failed"; exit 1; }

echo "🚀 Caching config, routes, and views after build..."
php artisan config:cache || { echo "❌ Failed to cache config"; exit 1; }
php artisan view:cache || { echo "❌ Failed to cache views"; exit 1; }
php artisan route:cache || { echo "Failed to cache routes"; exit 1; }

echo "✅ Deployment complete!"
