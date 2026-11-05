import { Database } from "bun:sqlite";
import { mkdirSync } from "node:fs";
import { dirname } from "node:path";

const port = Number(Bun.env.PORT) || 3000;
const dbPath = Bun.env.DB_PATH || "./data/app.db";

// --- Ensure the database directory exists (e.g. /data/db/app.db -> /data/db) ---
mkdirSync(dirname(dbPath), { recursive: true });

// --- Open (or create) the SQLite database and set up the schema ---
const db = new Database(dbPath, { create: true });
db.run(`
  CREATE TABLE IF NOT EXISTS users (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    name  TEXT NOT NULL,
    email TEXT NOT NULL
  )
`);

// INSERT ... RETURNING gives us the generated id and the stored row in one round-trip
const insertUser = db.prepare(
  "INSERT INTO users (name, email) VALUES ($name, $email) RETURNING id, name, email"
);
const listUsers = db.prepare(
  "SELECT id, name, email FROM users ORDER BY id"
);

// --- Static responses ---
const NOT_FOUND_HTML = `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>404 - Not Found</title>
  </head>
  <body>
    <h1>404 - Page Not Found</h1>
    <p>Whatever you were looking for isn't here.</p>
  </body>
</html>`;

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json; charset=utf-8" },
  });
}

// --- Server ---
const server = Bun.serve({
  port,
  async fetch(req) {
    const { pathname } = new URL(req.url);

    // Health check
    if (pathname === "/health") {
      return new Response("OK", {
        status: 200,
        headers: { "Content-Type": "text/plain; charset=utf-8" },
      });
    }

    // Insert a user
    if (pathname === "/users" && req.method === "POST") {
      let body;
      try {
        body = await req.json();
      } catch {
        return json({ error: "Request body must be valid JSON" }, 400);
      }

      const { name, email } = body ?? {};
      if (!name || !email) {
        return json({ error: "Fields 'name' and 'email' are required" }, 400);
      }

      const created = insertUser.get({
        $name: String(name),
        $email: String(email),
      });

      return json(
        { id: Number(created.id), name: created.name, email: created.email },
        201
      );
    }

    // List all users
    if (pathname === "/users" && req.method === "GET") {
      return json(listUsers.all(), 200);
    }

    // Everything else -> 404
    return new Response(NOT_FOUND_HTML, {
      status: 404,
      headers: { "Content-Type": "text/html; charset=utf-8" },
    });
  },
});

console.log(`Listening on http://localhost:${server.port}`);
console.log(`SQLite database at ${dbPath}`);