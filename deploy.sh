#!/usr/bin/env bash
# ديبلوي بأمر واحد: commit + push + تشغيل Easypanel deploy webhooks
# الاستخدام:  ./deploy.sh "رسالة الكوميت"
#   - لو مفيش تغييرات، بيتخطّى الكوميت ويعمل ديبلوي فقط.
#   - محتاج ملف .deploy.env فيه BACKEND_DEPLOY_HOOK و FRONTEND_DEPLOY_HOOK
set -e
cd "$(dirname "$0")"

MSG="${1:-deploy: $(date +%Y-%m-%d\ %H:%M)}"

# 1) commit + push (لو في تغييرات)
if [ -n "$(git status --porcelain)" ]; then
  echo "▶ Commit + Push..."
  git add -A
  git commit -m "$MSG"
else
  echo "▶ لا توجد تغييرات جديدة — push فقط."
fi
git push origin main

# 2) تشغيل webhooks الديبلوي
if [ -f .deploy.env ]; then
  # shellcheck disable=SC1091
  source .deploy.env
  if [ -n "$BACKEND_DEPLOY_HOOK" ]; then
    echo "▶ Deploy backend..."
    curl -fsS -X POST "$BACKEND_DEPLOY_HOOK" && echo " ✓"
  fi
  if [ -n "$FRONTEND_DEPLOY_HOOK" ]; then
    echo "▶ Deploy frontend..."
    curl -fsS -X POST "$FRONTEND_DEPLOY_HOOK" && echo " ✓"
  fi
  echo "✅ تم إرسال طلبات الديبلوي — تابع البناء في Easypanel."
else
  echo "⚠ .deploy.env غير موجود — تم الـ push فقط."
  echo "  انسخ .deploy.env.example إلى .deploy.env واملأ روابط Easypanel."
fi

# تذكير بالهجرة عند تغيّر schema
if git diff --name-only HEAD~1 2>/dev/null | grep -q "database/migration.sql\|database/schema.sql"; then
  echo ""
  echo "🗄  تنبيه: تغيّر ملف قاعدة البيانات — لو في أعمدة/جداول جديدة، شغّل database/migration.sql على قاعدة الإنتاج."
fi
