#!/bin/sh
# Script to generate code using build_runner

echo "Cleaning old generated files..."
flutter clean

echo "Getting dependencies..."
flutter pub get

echo "Generating Hive adapters, MobX stores, and auto routes..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "Build completed successfully!" 