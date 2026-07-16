# Task Manager - DevOps Demo Project

Full-stack Task Manager app: **React + Node.js/Express + PostgreSQL**, built as the
application layer for an end-to-end DevOps/GitOps pipeline
(Docker → Jenkins → DockerHub → Kubernetes → ArgoCD → Prometheus/Grafana).

## Project Structure
```
taskmanager/
├── backend/          # Node.js + Express API
│   ├── routes/
│   │   └── tasks.js
│   ├── db.js
│   ├── server.js
│   ├── init.sql      # DB schema + seed data
│   ├── Dockerfile
│   └── package.json
├── frontend/          # React (Vite) app
│   ├── src/
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── nginx.conf      # Serves build + proxies /api to backend
│   ├── Dockerfile
│   └── package.json
└── docker-compose.yml
```

## Run Locally (Phase 1 & 2 - no Kubernetes yet)

### Option 1: With Docker Compose (recommended)
```bash
cd taskmanager
docker-compose up --build
```
- Frontend: http://localhost:8080
- Backend API: http://localhost:5000/api/tasks
- Postgres: localhost:5432 (user: postgres / pass: postgres)

To stop: `docker-compose down`
To stop and wipe DB data: `docker-compose down -v`

### Option 2: Without Docker (plain Node, for quick local dev)
1. Start Postgres locally, create DB `taskmanager`, run `backend/init.sql`.
2. Backend:
   ```bash
   cd backend
   cp .env.example .env   # edit DB_HOST=localhost
   npm install
   npm run dev
   ```
3. Frontend:
   ```bash
   cd frontend
   npm install
   echo "VITE_API_URL=http://localhost:5000/api/tasks" > .env
   npm run dev
   ```
   Open http://localhost:3000

## Next Steps (DevOps Pipeline)
1. ✅ **Phase 1-2 (this step):** App code + Dockerized (docker-compose works locally)
2. **Phase 3:** Push code to GitHub, push images to DockerHub
3. **Phase 4:** Jenkins CI pipeline (build → test → docker build → push)
4. **Phase 5:** Local Kubernetes (Minikube/Kind) + manifests (Deployment, Service, PV/PVC for Postgres)
5. **Phase 6:** ArgoCD GitOps (separate manifests repo, auto-sync deployment)
6. **Phase 7:** Prometheus + Grafana monitoring

See project roadmap for full details on each phase.
