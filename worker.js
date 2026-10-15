
export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname !== "/") {
      return new Response("Not Found", { status: 404 });
    }

    const assetUrl = new URL("/install.sh", url.origin);
    const response = await fetch(assetUrl);

    if (!response.ok) {
      return new Response("Installer script not found", {
        status: 404,
      });
    }

    return new Response(response.body, {
      headers: {
        "Content-Type": "text/plain; charset=utf-8",
        "Cache-Control": "no-cache",
      },
    });
  },
};
