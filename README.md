# MERN DevOps Practice App

A simple MERN stack task board app for DevOps practice.

- Frontend: React (Vite)
- Backend: Node.js + Express + Mongoose
- Database: MongoDB Atlas

## Project Structure

- `frontend` - React client app
- `backend` - Express API

## Prerequisites

- Node.js 18+
- npm
- MongoDB Atlas cluster

## Environment Configuration

This repository currently uses existing `.env` files in both apps.

### Backend `.env`

Location: `backend/.env`

Required variables:

- `PORT=5000`
- `MONGODB_URI=<your-atlas-connection-string>`
- `MONGODB_DB_NAME=mern_devops_practice`
- `FRONTEND_URL=http://localhost:5173`

Atlas URI example:

`mongodb+srv://<username>:<password>@<cluster-url>/?retryWrites=true&w=majority`

### Frontend `.env`

Location: `frontend/.env`

Required variable:

- `VITE_API_URL=http://localhost:5000/api`

## Install Dependencies

From the repository root:

```bash
npm install
npm install --prefix backend
npm install --prefix frontend
```

## Run the App

### Option 1: Run both apps from root

```bash
npm run dev
```

### Option 2: Run separately

Backend:

```bash
npm run dev --prefix backend
```

Frontend:

```bash
npm run dev --prefix frontend
```

## URLs

- Frontend: `http://localhost:5173`
- Backend health: `http://localhost:5000/api/health`

## API Endpoints

- `GET /api/health`
- `GET /api/tasks`
- `POST /api/tasks`
- `PATCH /api/tasks/:id/toggle`

## Notes

- A database is created in Atlas when the first write operation occurs.
- The DB name is controlled by `MONGODB_DB_NAME` in `backend/.env`.
# mern-devops-practice
