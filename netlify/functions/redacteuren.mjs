// GET /api/redacteuren – de namen waaruit je kiest bij "Ik ben …".
import { behandel, json } from "../lib/server.mjs";
import { REDACTEUREN } from "../lib/redacteuren.mjs";

export default behandel(async () => json({ redacteuren: REDACTEUREN }));

export const config = { path: "/api/redacteuren", method: "GET" };
