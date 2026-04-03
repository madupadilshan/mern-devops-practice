import { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';

// Resolve API URL from env and fall back to same-host backend.
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || `http://${window.location.hostname}:5000/api`,
});

function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const doneCount = tasks.filter((task) => task.done).length;

  const loadTasks = async () => {
    setLoading(true);
    setError('');

    try {
      // Load tasks ordered by newest first (from backend).
      const response = await api.get('/tasks');
      setTasks(response.data);
    } catch {
      setError('Failed to load tasks. Please check Backend/Atlas.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadTasks();
  }, []);

  const createTask = async (event) => {
    event.preventDefault();
    const normalizedTitle = title.trim();

    if (!normalizedTitle) {
      return;
    }

    setSaving(true);
    setError('');

    try {
      // Create and prepend a new task in local state.
      const response = await api.post('/tasks', { title: normalizedTitle });
      setTasks((previous) => [response.data, ...previous]);
      setTitle('');
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to save task.');
    } finally {
      setSaving(false);
    }
  };

  const toggleTask = async (taskId) => {
    setError('');

    try {
      const response = await api.patch(`/tasks/${taskId}/toggle`);

      // Replace only the updated task returned by the API.
      setTasks((previous) =>
        previous.map((task) =>
          task._id === taskId ? response.data : task
        )
      );
    } catch {
      setError('Failed to update task status.');
    }
  };

  return (
    <main className="app-shell">
      <section className="panel hero-panel">
        <p className="eyebrow">MERN + Atlas</p>
        <h1>DevOps Practice Task Board</h1>
        <p className="subtitle">
          Test the complete flow of Frontend (React) + Backend (Express) + DB
          (MongoDB Atlas) in a single app.
        </p>
        <div className="stats-row">
          <article>
            <span>Total</span>
            <strong>{tasks.length}</strong>
          </article>
          <article>
            <span>Done</span>
            <strong>{doneCount}</strong>
          </article>
          <article>
            <span>Pending</span>
            <strong>{Math.max(tasks.length - doneCount, 0)}</strong>
          </article>
        </div>
      </section>

      <section className="panel task-panel">
        <form onSubmit={createTask} className="task-form">
          <input
            value={title}
            onChange={(event) => setTitle(event.target.value)}
            placeholder="New task title"
            maxLength={120}
          />
          <button type="submit" disabled={saving}>
            {saving ? 'Saving...' : 'Add Task'}
          </button>
        </form>

        {error && <p className="error-banner">{error}</p>}

        {loading ? (
          <p className="info-text">Loading tasks...</p>
        ) : tasks.length === 0 ? (
          <p className="info-text">No tasks yet. Add your first task.</p>
        ) : (
          <ul className="task-list">
            {tasks.map((task) => (
              <li key={task._id} className={task.done ? 'done' : ''}>
                <div>
                  <h3>{task.title}</h3>
                  <small>
                    {new Date(task.createdAt).toLocaleString()}
                  </small>
                </div>
                <button
                  type="button"
                  onClick={() => toggleTask(task._id)}
                >
                  {task.done ? 'Mark Pending' : 'Mark Done'}
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  );
}

export default App;
