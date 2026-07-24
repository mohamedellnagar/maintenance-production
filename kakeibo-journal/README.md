# Kakeibo Journal

دفتر كاكيبو رقمي بسيط — تطبيق ويب موبايل (React + Vite) يحوّل دفتر Kakeibo الورقي إلى رحلة رقمية خطوة بخطوة، مع الحفاظ على فلسفة **"فكّر قبل أن تصرف"**.

A calm, minimal digital Kakeibo journal built as a mobile-first PWA. All data is stored **locally on the device** (localStorage) — no backend, no accounts, no tracking.

> ملاحظة: هذا المشروع مستقل تماماً عن نظام `maintenance-production` في هذا المستودع، ويعيش في مجلده الخاص. متطلبات العمل الكاملة في [`docs/kakeibo-journal-brd.md`](../docs/kakeibo-journal-brd.md).

## المزايا (Features)

- **رحلة خطوة بخطوة (Wizard):** Splash → Onboarding → إنشاء شهر → تخطيط أسبوعي → تسجيل يومي → تأمل نهاية الأسبوع → تأمل نهاية الشهر → شهر جديد.
- **الشاشة الرئيسية بأربع بطاقات:** الدخل، المصاريف الثابتة، هدف الادخار، والمتاح للإنفاق (يُحسب آلياً = الدخل − الثابتة − الادخار).
- **الفئات الأربع:** Needs / Wants / Culture / Unexpected مع المخطط والفعلي والفرق لكل أسبوع.
- **إضافة مصروف في 3 خطوات:** التاريخ، البند، الفئة، المبلغ فقط.
- **سجل الأسبوع** ببطاقات، **تأمل نهاية الأسبوع** (سؤال الفخر)، و**أسئلة نهاية الشهر الأربعة**.
- **أرشيف الأشهر** للقراءة فقط بعد الإغلاق.
- **ثنائي اللغة:** عربي (RTL) / إنجليزي (LTR)، خط Cairo، هوية بصرية هادئة (Cream / Beige / Dark Blue / Gold).
- **تخزين محلي** — يعمل دون اتصال، وقابل للتثبيت كـ PWA.

## التشغيل (Getting started)

```bash
cd kakeibo-journal
npm install
npm run dev       # http://localhost:5174
```

للبناء للإنتاج:

```bash
npm run build     # ينتج مجلد dist/
npm run preview   # معاينة نسخة الإنتاج محلياً
```

## البنية (Project structure)

```
kakeibo-journal/
├─ index.html
├─ vite.config.js
├─ public/manifest.webmanifest
└─ src/
   ├─ main.jsx          # نقطة الدخول
   ├─ App.jsx           # التنقل (تبويبات + Stack)
   ├─ store.jsx         # الحالة + التخزين المحلي + الحسابات
   ├─ i18n.js           # القاموس ثنائي اللغة + الفئات
   ├─ format.js         # تنسيق المبالغ والتواريخ
   ├─ ui.jsx            # مكونات واجهة مشتركة
   ├─ styles.css        # الهوية البصرية
   └─ screens/
      ├─ Onboarding.jsx # Splash + التعريف + إنشاء أول شهر
      ├─ Month.jsx      # الرئيسية + الدخل + الثابتة + الادخار + نهاية الشهر
      ├─ Week.jsx       # الأسابيع + إضافة مصروف + السجل + نهاية الأسبوع
      ├─ History.jsx    # الأشهر السابقة (قراءة فقط)
      └─ Settings.jsx   # اللغة + العملة + حذف البيانات
```

## البيانات (Data)

كل البيانات محفوظة في `localStorage` تحت المفتاح `kakeibo.journal.v1`. لا تُرسَل أي بيانات لأي خادم. حذف بيانات المتصفح أو استخدام زر "حذف كل البيانات" في الإعدادات يمسح كل شيء.
