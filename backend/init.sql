CREATE TABLE IF NOT EXISTS tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  completed BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

-- sample seed data
INSERT INTO tasks (title, description, completed)
VALUES
  ('Setup Jenkins pipeline', 'Configure CI/CD for automated builds', false),
  ('Deploy to Kubernetes', 'Create manifests and deploy via ArgoCD', false),
  ('Configure Monitoring', 'Setup Prometheus + Grafana dashboards', false)
ON CONFLICT DO NOTHING;
