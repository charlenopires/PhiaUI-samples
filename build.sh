#!/usr/bin/env bash
set -e

echo "==> Installing dependencies..."
mix deps.get --only prod

echo "==> Installing asset build tools..."
mix tailwind.install --if-missing
mix esbuild.install --if-missing

echo "==> Compiling (prod)..."
MIX_ENV=prod mix compile

echo "==> Building and deploying assets..."
MIX_ENV=prod mix assets.deploy

echo "==> Generating release..."
MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite

echo "==> Build complete."
