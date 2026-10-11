import { getStore } from "@netlify/blobs";
import { db } from "../lib/server.mjs";
import { maakBestandscontrole } from "../lib/agent-files.mjs";
import { bouwAgentSnapshot, leesAgentRijen } from "../lib/agent-export.mjs";
import { maakAgentHandler } from "../lib/agent-handler.mjs";

const bestandscontrole = maakBestandscontrole(() => getStore({ name: "bijlagen", consistency: "strong" }));

export default maakAgentHandler({
  getToken: () => process.env.KNOWLEDGE_SYNC_TOKEN,
  getSnapshot: async () => bouwAgentSnapshot(await leesAgentRijen(db().pool), bestandscontrole),
});

// Methoden worden in Edge én handler gecontroleerd: ook POST/HEAD krijgt JSON 405.
export const config = { path: ["/api/agent/manifest", "/api/agent/export"] };
