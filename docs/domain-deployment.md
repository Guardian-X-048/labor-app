# laborlinks.in domain deployment runbook

This runbook deploys:

- Frontend on Firebase Hosting (`laborlinks.in`, `www.laborlinks.in`)
- Backend on Render (`api.laborlinks.in`)

## 1) Deploy backend to Render

1. Push this repository to GitHub.
2. In Render dashboard, create a new Web Service from the repo.
3. Render will auto-detect `render.yaml` in repo root.
4. Set secrets in Render environment:
   - `MONGO_URI`
   - `JWT_SECRET`
5. Deploy and copy the backend URL (for example `https://labor-app-backend.onrender.com`).
6. Validate health endpoint:
   - `https://<your-render-service>/health`

## 2) Deploy frontend to Firebase Hosting

From `labor-app/frontend`:

```bash
flutter build web --release
npm install -g firebase-tools
firebase login
firebase init hosting
```

When prompted in `firebase init hosting`:

- Select your Firebase project
- Public directory: `build/web`
- Configure as single-page app: `Yes`
- Set up automatic builds and deploys with GitHub: optional

Then deploy:

```bash
firebase deploy --only hosting
```

## 3) Add DNS records for laborlinks.in

In your domain registrar DNS panel, add these records.

### Frontend records (Firebase Hosting)

Firebase gives exact records in its custom domain wizard. Usually:

- `@` A records to Firebase IPs
- `www` CNAME to `ghs.googlehosted.com`

### Backend record (Render)

- Type: `CNAME`
- Host/Name: `api`
- Value/Target: your Render service host (without https://)
  - Example: `labor-app-backend.onrender.com`

## 4) Attach custom domains in hosting providers

1. Firebase Hosting: add domains `laborlinks.in` and `www.laborlinks.in`.
2. Render: add custom domain `api.laborlinks.in`.
3. Wait for SSL certificates to be issued automatically.

## 5) Final backend CORS check

Ensure backend env var:

- `CORS_ORIGINS=https://laborlinks.in,https://www.laborlinks.in`

Then trigger a redeploy in Render.

## 6) Validation checklist

- `https://laborlinks.in` opens frontend
- `https://www.laborlinks.in` opens frontend
- `https://api.laborlinks.in/health` returns `{ "status": "ok" }`
- Browser network calls to API are successful (no CORS errors)
