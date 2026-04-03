# MERN DevOps Practice App

A simple MERN task board used for DevOps and deployment practice.

## Stack

- Frontend: React + Vite
- Backend: Node.js + Express + Mongoose
- Database: MongoDB Atlas

## Project Folders

- frontend: React client
- backend: Express API
- terraform: AWS infrastructure

## Prerequisites

- Node.js 18+
- npm
- MongoDB Atlas cluster

## Environment Variables

Backend file: backend/.env

- PORT=5000
- MONGODB_URI=<atlas-connection-string>
- MONGODB_DB_NAME=mern_devops_practice
- FRONTEND_URL=http://localhost:5173

Frontend file: frontend/.env

- VITE_API_URL=http://localhost:5000/api

## Install

```bash
npm install
npm install --prefix backend
npm install --prefix frontend
```

## Run

Run both apps:

```bash
npm run dev
```

Run separately:

```bash
npm run dev --prefix backend
npm run dev --prefix frontend
```

## API Endpoints

- GET /api/health
- GET /api/tasks
- POST /api/tasks
- PATCH /api/tasks/:id/toggle
