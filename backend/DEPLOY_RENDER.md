# Render Deployment

## Files added
- `requirements.txt`
- `build.sh`
- `render.yaml`

## Required environment variables
- `SECRET_KEY`
- `DATABASE_URL`

## Optional environment variables
- `ALLOWED_HOSTS`
- `CORS_ALLOWED_ORIGINS`
- `CORS_ALLOW_ALL_ORIGINS`
- `DEBUG`

## Render setup
1. Push this repository to GitHub.
2. In Render, create a new PostgreSQL database.
3. Create a new Web Service and point it to this repository.
4. Use `backend/render.yaml` with Blueprint deploy, or configure manually with:
   - Root Directory: `backend`
   - Build Command: `./build.sh`
   - Start Command: `gunicorn cargolink_backend.wsgi:application`
5. Add the `DATABASE_URL` from your Render Postgres instance.
6. Add your frontend URL to `CORS_ALLOWED_ORIGINS`.

## Notes
- `build.sh` runs migrations and `collectstatic`.
- The settings file reads `RENDER_EXTERNAL_HOSTNAME` automatically.
- SQLite is only for local development. Use Postgres on Render.
