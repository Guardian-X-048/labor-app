# Labor App

A starter full-stack app for connecting labor workers with local jobs.

## GitHub-Ready Notes

- Keep backend secrets in `backend/.env` and commit only `backend/.env.example`.
- Generated folders such as `backend/node_modules/`, `database/node_modules/`, and `frontend/build/` are ignored.
- The Flutter frontend supports web and mobile.

## Project Structure

- `frontend/`: Flutter mobile app.
- `backend/`: Node.js + Express API with MongoDB models.
- `database/`: Seed scripts.
- `docs/`: Notes, diagrams, and pitch material.

## Quick Start

### 1) Backend

```bash
cd backend
npm install
npm run dev
```

Backend runs on `http://localhost:5000`.

### 2) Seed sample jobs (optional)

```bash
cd backend
npm run seed
```

### 3) Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## Core API Endpoints

- `POST /api/auth/signup`
- `POST /api/auth/login`
- `GET /api/jobs`
- `POST /api/jobs` (auth required)
- `POST /api/aadhaar/verify` (auth required)

## Custom Domain Setup

Use your main domain for frontend and a subdomain for API:

- Frontend: `https://laborlinks.in` and `https://www.laborlinks.in`
- Backend API: `https://api.laborlinks.in`

Recommended deployment flow:

1. Deploy backend (Render, Railway, or similar) and copy the backend public URL.
2. Deploy Flutter web frontend and copy the frontend public URL.
3. In your domain DNS panel, add records:
	- `@` -> A/CNAME as required by your frontend host
	- `www` -> CNAME to frontend host target
	- `api` -> CNAME to backend host target
4. In backend environment variables, set `CORS_ORIGINS` to:
	- `https://laborlinks.in,https://www.laborlinks.in`
5. Enable HTTPS/SSL in both hosting dashboards and wait for DNS propagation.
