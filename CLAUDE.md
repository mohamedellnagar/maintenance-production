# Maintenance Production

نظام لتتبع أعمال الصيانة اليومية للفلل والشقق (لوحة تحكم + API)، باللغة العربية بشكل أساسي (RTL).

## Stack

- **Backend**: Node.js + Express (ES modules), entry `backend/src/server.js`, port 4000
- **Frontend**: React + Vite, entire app in one file `frontend/src/main.jsx`, served via Nginx on port 8080 in Docker (dev: Vite default 5173)
- **Database**: MySQL 8.0, schema in `database/schema.sql`, charset utf8mb4 (Arabic support)
- **Orchestration**: `docker-compose.yml` — services `mysql`, `backend`, `frontend`

## Architecture notes

- Backend is monolithic: all routes live in `backend/src/server.js`, including a generic `crud()` helper used for `villas` and `technicians`. Apartments, users, records, and reports have custom handlers.
- Auth: JWT (12h expiry) via `backend/src/middleware/auth.js`. Two guards: `auth` (valid token required) and `adminOnly` (role === ADMIN). Roles: `ADMIN`, `SUPERVISOR`.
- Frontend has no router and no global state library — page switching is local `useState`, API calls via a custom `useApi()` hook that reads the JWT from `localStorage.token`.
- DB access via `mysql2/promise` pool (`backend/src/config/db.js`), parameterized queries (`?` placeholders) — no raw string interpolation in SQL.
- API responses wrap data as `{ data: ... }`.

## Domain model

- **villas** (فلل) → has many **apartments** (شقق), unique on `(villa_id, apartment_no)`, cascade delete
- **technicians** (فنيين) — specialty, phone
- **maintenance_records** (كشوف الصيانة) — core entity: links villa, apartment, technician, created_by (user); tracks `reported_time`/`completed_time`, `spare_part`/`spare_part_cost`, notes
- **users** — ADMIN/SUPERVISOR, bcryptjs password hashing

## Key endpoints (`/api/...`)

- `POST /auth/login`, `GET /health`
- `GET /dashboard` — today/month KPIs, top 8 technicians/villas, recent records
- `/villas`, `/technicians` — generic CRUD (delete = admin only)
- `/apartments` — filter by `villa_id`
- `/users` — admin only
- `/records` — filter by date/villa/apartment/technician
- `/reports/summary` — daily aggregation by date range

## Running locally

- Docker: `docker compose up -d --build` (mysql on host port 3307, backend 4000, frontend 8080)
- Without Docker: `npm run install:all` then `npm run dev` (runs backend + frontend concurrently)
- Demo login: `admin@maintenance.local` / `Admin@12345`

## Gaps to be aware of

- No tests, no linting, no CI configured.
- `zod` is a dependency but not actually used for validation yet.
- Secrets (`JWT_SECRET`, MySQL password) are hardcoded in `docker-compose.yml`/`.env.example` for dev convenience — must be changed before any real production deploy.
