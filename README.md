# MaintenancePro - Production Maintenance Dashboard

نظام إنتاجي لإدارة كشف الصيانة اليومي للفلل والشقق، مبني على MySQL.

## المكونات
- Backend: Node.js + Express
- Database: MySQL 8
- Frontend: React + Vite
- Charts: Recharts
- Auth: JWT + bcrypt
- Deployment: Docker Compose

## التشغيل باستخدام Docker
```bash
docker compose up -d --build
```

ثم افتح:
```text
http://localhost:8080
```

بيانات الدخول الافتراضية:
```text
Email: admin@maintenance.local
Password: Admin@12345
```

## تشغيل محلي بدون Docker
1. أنشئ قاعدة MySQL (utf8mb4) وشغّل `database/schema.sql` **مع تحديد الترميز صريحًا** حتى لا تتلف النصوص العربية:
```bash
mysql -u root -p --default-character-set=utf8mb4 -e "CREATE DATABASE maintenance_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p --default-character-set=utf8mb4 maintenance_db < database/schema.sql
```
2. انسخ `backend/.env.example` إلى `backend/.env` وعدل بيانات الاتصال.
3. ثبّت الحزم:
```bash
npm run install:all
```
4. شغّل:
```bash
npm run dev
```

## الموديولات
- تسجيل دخول وصلاحيات: ADMIN / SUPERVISOR
- إدارة المستخدمين
- إدارة الفلل
- إدارة الشقق داخل كل فيلا
- إدارة الفنيين
- إدخال كشف الصيانة اليومي
- تعديل وحذف السجلات
- Dashboard تحليل لايف
- تقارير حسب الفني والفيلا
- تصدير CSV يمكن فتحه على Excel

## ملاحظات Production
- غيّر JWT_SECRET قبل النشر.
- غيّر كلمة مرور MySQL.
- اربط Nginx أو Reverse Proxy على دومينك.
- استخدم HTTPS.


