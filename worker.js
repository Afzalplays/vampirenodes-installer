export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname !== "/" && url.pathname !== "/install.sh") {
      return new Response("Not Found", { status: 404 });
    }

    const assetUrl = new URL("/install.sh", request.url);

    const assetRequest = new Request(assetUrl, request);
    const response = await env.ASSETS.fetch(assetRequest);

    if (!response.ok) {
      return new Response("Installer script not found in public/install.sh", {
        status: 404,
      });
    }

    const headers = new Headers(response.headers);
    headers.set("Content-Type", "text/plain; charset=utf-8");
    headers.set("Cache-Control", "no-cache");

    return new Response(response.body, {
      status: response.status,
      headers,
    });
  },
};
