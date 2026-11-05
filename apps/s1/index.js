const port = Number(process.env.PORT) || 3000;

const HTML = `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Hello</title>
</head>
<body>
  <h1>It works!</h1>
  <p>This is a hardcoded page served by Bun.</p>
</body>
</html>`;

const server = Bun.serve({
  port,
  fetch(req) {
    const url = new URL(req.url);
    if (url.pathname === "/health") {
      return new Response("OK", { status: 200 });
    }
    return new Response(HTML, {
      status: 200,
      headers: { "Content-Type": "text/html; charset=utf-8" },
    });
  },
});

console.log(`Listening on http://localhost:${server.port}`);