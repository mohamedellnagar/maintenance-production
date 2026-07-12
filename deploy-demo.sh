#!/usr/bin/env bash
# ديبلوي نسخة الديمو على Easypanel (تعيد بناء الخدمتين من آخر كود على main).
# ملاحظة: الديمو يبني من نفس repo/main، فالكود لازم يكون مرفوعاً (git push) قبلها.
# الاستخدام:  ./deploy-demo.sh
set -e
cd "$(dirname "$0")"

if [ ! -f .deploy.demo.env ]; then
  echo "⚠ .deploy.demo.env غير موجود — ضع فيه DEMO_BACKEND_HOOK و DEMO_FRONTEND_HOOK."
  exit 1
fi
# shellcheck disable=SC1091
source .deploy.demo.env

echo "▶ Deploy DEMO backend..."
curl -fsS -X POST "$DEMO_BACKEND_HOOK" && echo " ✓"
echo "▶ Deploy DEMO frontend..."
curl -fsS -X POST "$DEMO_FRONTEND_HOOK" && echo " ✓"
echo "✅ تم إرسال طلبات ديبلوي الديمو — تابع البناء في Easypanel."
