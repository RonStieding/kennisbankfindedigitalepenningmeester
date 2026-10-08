import { agentAntwoord, controleerAgentToegang } from "./agent-access.mjs";

export function maakAgentHandler({ getToken, getSnapshot, logError = console.error }) {
  return async (request) => {
    const denied = await controleerAgentToegang(request, getToken());
    if (denied) return denied;
    const url = new URL(request.url);
    const isExport = url.pathname === "/api/agent/export";
    const expected = url.searchParams.get("snapshot_id");
    if ([...url.searchParams.keys()].some((key) => key !== "snapshot_id") ||
        url.searchParams.getAll("snapshot_id").length > 1 ||
        (expected !== null && (!isExport || !/^sha256:[a-f0-9]{64}$/.test(expected)))) {
      return agentAntwoord({ error: "invalid_query" }, 400);
    }
    try {
      const { manifest, exported } = await getSnapshot();
      if (expected && expected !== manifest.snapshot_id) {
        return agentAntwoord({ error: "snapshot_changed", snapshot_id: manifest.snapshot_id }, 409);
      }
      const data = isExport ? exported : manifest;
      const body = JSON.stringify(data);
      // Ruimte voor headers/Netlify envelope onder de buffered-response limiet.
      if (new TextEncoder().encode(body).length > 5 * 1024 * 1024) {
        return agentAntwoord({ error: "export_too_large" }, 503);
      }
      const etag = `"${isExport ? "export" : "manifest"}-v1-${data.snapshot_id}"`;
      const condition = request.headers.get("if-none-match") || "";
      const matches = condition.trim() === "*" || condition.split(",").some(
        (candidate) => candidate.trim().replace(/^W\//, "") === etag,
      );
      if (matches) return agentAntwoord(null, 304, { ETag: etag });
      return agentAntwoord(data, 200, { ETag: etag });
    } catch {
      // Log geen databasefouten met mogelijke inhoud of verbindingsgegevens.
      logError("Agentexport mislukt: bron niet volledig beschikbaar.");
      return agentAntwoord({ error: "source_unavailable" }, 503);
    }
  };
}
