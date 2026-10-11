import { createHash } from "node:crypto";

const SHA256 = /^[a-f0-9]{64}$/;
const MAX_GROOTTE = 5 * 1024 * 1024;

// Nieuwe uploads hebben een serverberekende hash in Blob-metadata. Oudere blobs
// worden alleen gelezen, nooit herschreven. De begrensde cache gebruikt de Blob-ETag.
export function maakBestandscontrole(getStore) {
  const cache = new Map();
  return async (sleutel) => {
    if (!/^bestanden\/\d{8}-[0-9a-f-]{36}$/.test(sleutel)) throw new Error("Ongeldige bestandssleutel");
    const store = getStore();
    const info = await store.getMetadata(sleutel);
    if (!info) throw new Error("Goedgekeurd bestand ontbreekt");
    const metadata = info.metadata || {};
    const grootte = Number(metadata.grootte);
    if (!Number.isSafeInteger(grootte) || grootte <= 0 || grootte > MAX_GROOTTE || typeof metadata.mime !== "string") {
      throw new Error("Ongeldige bestandsmetadata");
    }
    if (SHA256.test(metadata.sha256 || "")) {
      return { sha256: metadata.sha256, size: grootte, mime: metadata.mime };
    }
    const cacheKey = info.etag ? `${sleutel}:${info.etag}` : null;
    if (cacheKey && cache.has(cacheKey)) return cache.get(cacheKey);
    const blob = await store.getWithMetadata(sleutel, { type: "arrayBuffer" });
    if (!blob || !(blob.data instanceof ArrayBuffer) || blob.data.byteLength !== grootte ||
        (info.etag && blob.etag !== info.etag)) {
      throw new Error("Bestand ontbreekt of is tijdens het lezen gewijzigd");
    }
    const result = {
      sha256: createHash("sha256").update(new Uint8Array(blob.data)).digest("hex"),
      size: grootte,
      mime: metadata.mime,
    };
    if (cacheKey) {
      if (cache.size >= 128) cache.delete(cache.keys().next().value);
      cache.set(cacheKey, result);
    }
    return result;
  };
}
