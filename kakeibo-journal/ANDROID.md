# بناء تطبيق أندرويد ورفعه على Google Play

هذا التطبيق مبني بـ **Capacitor**، فهو تطبيق أندرويد نيتف حقيقي يغلّف واجهة الويب ويعمل **أوفلاين بالكامل** (كل البيانات محلية على الجهاز، بلا سيرفر). المخرجات:

- **APK للاختبار** — تثبّته مباشرة على أي هاتف أندرويد.
- **AAB موقّع (`.aab`)** — هذا ما ترفعه على Google Play.

> `applicationId` الحالي: **`com.kakeibo.journal`** — هذا المعرّف يجب أن يكون فريداً على Play ولا يتغيّر بعد النشر. لتغييره عدّل `android/app/build.gradle` و `capacitor.config.json`.

---

## الطريقة الأسهل — بناء عبر GitHub Actions (بدون تنصيب أي شيء)

يوجد workflow جاهز: `.github/workflows/android.yml`.

### 1) الحصول على APK للاختبار فوراً (بدون توقيع)

1. من GitHub افتح تبويب **Actions**.
2. اختر **Build Android App (Kakeibo Journal)** ثم **Run workflow**.
3. بعد انتهاء البناء، نزّل الـ artifact باسم **`kakeibo-debug-apk`**.
4. انقل `app-debug.apk` للهاتف وثبّته (فعّل "تثبيت من مصادر غير معروفة"). هذا للاختبار فقط ولا يصلح لرفعه على Play.

### 2) إنتاج AAB موقّع جاهز لـ Google Play

**أ. أنشئ مفتاح التوقيع (Keystore) مرة واحدة** على جهازك (يتطلب Java):

```bash
keytool -genkey -v -keystore release.keystore \
  -alias kakeibo -keyalg RSA -keysize 2048 -validity 10000
```

احتفظ بـ `release.keystore` وكلمات المرور في مكان آمن — فقدانها يعني عدم قدرتك على تحديث التطبيق لاحقاً.

**ب. حوّل الـ keystore إلى Base64:**

```bash
base64 -w0 release.keystore     # لينكس
base64 -i release.keystore      # ماك
```

**ج. أضِف الأسرار في GitHub** (Settings → Secrets and variables → Actions → New repository secret):

| الاسم | القيمة |
|---|---|
| `KEYSTORE_BASE64` | ناتج الأمر السابق |
| `KEYSTORE_PASSWORD` | كلمة مرور الـ keystore |
| `KEY_ALIAS` | `kakeibo` (أو الـ alias الذي اخترته) |
| `KEY_PASSWORD` | كلمة مرور المفتاح |

**د. شغّل الـ workflow** مرة أخرى. نزّل الـ artifact **`kakeibo-release-aab`** — بداخله `app-release.aab` الجاهز للرفع.

> يمكنك تمرير `versionName` و `versionCode` عند تشغيل الـ workflow يدوياً لرفع رقم الإصدار دون تعديل الكود.

---

## رفع التطبيق على Google Play (باختصار)

1. أنشئ حساب مطوّر على [Google Play Console](https://play.google.com/console) (رسوم تسجيل لمرة واحدة).
2. **Create app** → اسم التطبيق واللغة ونوعه (تطبيق/مجاني).
3. من **Release → Production → Create new release** ارفع ملف `app-release.aab`.
4. فعّل **Play App Signing** (يوصى به — تحتفظ جوجل بمفتاح التوقيع النهائي وأنت ترفع بمفتاح الرفع الذي أنشأته).
5. أكمل بيانات المتجر المطلوبة: الوصف، لقطات الشاشة، أيقونة 512×512، صورة الغلاف 1024×500، سياسة الخصوصية، وتصنيف المحتوى.
6. أرسل للمراجعة.

> لكل تحديث لاحق: ارفع `versionCode` (رقم صحيح أكبر) و`versionName`، ابنِ AAB جديداً، وارفعه كإصدار جديد.

---

## البناء محلياً (اختياري — يتطلب Android Studio / Android SDK)

```bash
cd kakeibo-journal
npm install
npm run android:apk    # APK تجريبي في android/app/build/outputs/apk/debug/
npm run android:aab    # AAB في android/app/build/outputs/bundle/release/ (وقّعه بالـ keystore)
npm run android:open   # فتح المشروع في Android Studio
```

لبناء AAB موقّع محلياً، مرّر متغيرات البيئة:

```bash
export KEYSTORE_PATH=$PWD/release.keystore
export KEYSTORE_PASSWORD=... KEY_ALIAS=kakeibo KEY_PASSWORD=...
npm run android:aab
```

---

## الأيقونات والـ Splash

مصدر الأيقونة يُولَّد برمجياً من `scripts/make-icons.mjs` (خلفية Dark Blue + ريشة قلم Gold). لإعادة توليد كل المقاسات:

```bash
npm run icons
```

## تحديث محتوى التطبيق

أي تعديل على كود الويب (`src/`) يظهر في التطبيق بعد:

```bash
npm run cap:sync    # build + نسخ الأصول إلى مشروع أندرويد
```

ثم أعِد البناء (workflow أو محلياً).

## ملاحظات

- التطبيق يعمل **أوفلاين بالكامل**؛ خط Cairo مضمّن داخل الحزمة (لا يعتمد على الإنترنت).
- `minSdk = 24` (أندرويد 7.0 فأحدث)، `targetSdk = 36`.
- لا يطلب التطبيق أي أذونات حساسة ولا يجمع أي بيانات خارج الجهاز.
