#!/bin/bash
# إصلاح خطأ: resource fork, Finder information, or similar detritus not allowed
# شغّل من الطرفية داخل المشروع: bash scripts/fix_ios_codesign.sh

set -e
cd "$(dirname "$0")/.."

echo "▶ إزالة السمات الممتدة من مجلدات المشروع (بدون Pods)..."
for dir in lib ios/Runner build .dart_tool; do
  [ -d "$dir" ] && xattr -cr "$dir" 2>/dev/null && echo "   $dir ✓" || true
done

echo "▶ إزالة السمات من كاش محرك Flutter (مصدر Flutter.framework)..."
FLUTTER_ROOT=$(dirname "$(dirname "$(which flutter)")")
if [ -d "$FLUTTER_ROOT/bin/cache/artifacts/engine" ]; then
  xattr -cr "$FLUTTER_ROOT/bin/cache/artifacts/engine" 2>/dev/null && echo "   Flutter engine cache ✓" || true
fi

echo "▶ تنظيف مجلد البناء..."
flutter clean

echo "▶ جلب الحزم..."
flutter pub get

echo ""
echo "✅ انتهى. شغّل الآن:"
echo "   flutter run          (محاكي)"
echo "   أو  flutter build ios   (جهاز)"
