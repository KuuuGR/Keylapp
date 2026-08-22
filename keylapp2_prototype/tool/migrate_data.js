#!/usr/bin/env node
/**
 * Keylapp 2.0 — Data migration script
 *
 * Transforms the three legacy, name-joined sources into the canonical
 * layoutId-keyed dataset. This is a data-driven migration: no manual edits.
 *
 * Legacy sources:
 *   1. KeyboardLayoutData.swift  —  rawLayouts DSL (103 renderable layouts, full-width rows)
 *   2. KeyboardStats.json        —  83 metric entries (with authoritative variable-width geometry)
 *   3. KeyboardLayoutData.swift  —  allLayouts() descriptions (44 entries)
 *
 * Outputs (canonical, layoutId-keyed):
 *   assets/data/layouts.json       — every layout geometry + metadata
 *   assets/data/metrics.json       — metric measurements (+provenance) where available
 *   assets/data/descriptions.json  — prose where available
 *
 * Run:  node tool/migrate_data.js
 */
'use strict';

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const LEGACY_DIR = path.join(ROOT, 'tool', 'legacy');
const OUT_DIR = path.join(ROOT, 'assets', 'data');
const DSL_PATH = path.join(ROOT, '..', 'Keylapp', 'Keylapp', 'KeyboardLayoutData.swift');
const STATS_PATH = path.join(LEGACY_DIR, 'KeyboardStats.json');

// ---------------------------------------------------------------------------
// 1. Normalisation helpers — used purely to CREATE the stable id from a display
//    name on FIRST migration. The id is then immutable; renaming a display name
//    never changes the id again. This is the "one-time naturalisation" step.
// ---------------------------------------------------------------------------
function slugify(raw) {
  let s = String(raw || '')
    .trim()
    .toLowerCase();
  // Remove the analyser provenance suffix "(cmini)", "(Oxey)", "(Smudge)" etc.
  s = s.replace(/\s*\([^)]*\)\s*$/, '');
  // Remove other parentheticals (e.g. "(bhulik)", "(gq-fix)")
  s = s.replace(/\s*\([^)]*\)\s*/g, '');
  // Normalise some known cosmetic variations for first-pass matching.
  const replacements = {
    'mod-dh': 'moddh',
    'mod dh': 'moddh',
    "'": '',
    '’': '',
    ' ': '-',
  };
  for (const [k, v] of Object.entries(replacements)) {
    s = s.replaceAll(k, v);
  }
  // Keep letters, digits, hyphen; drop anything else.
  s = s.replace(/[^a-z0-9-]/g, '');
  return s.replace(/-+/g, '-').replace(/^-+|-+$/g, '');
}

function normalizeForMatch(name) {
  return String(name || '')
    .toLowerCase()
    .replace(/\s*\([^)]*\)\s*$/g, '')
    .replace(/[^a-z0-9]/g, '');
}

// ---------------------------------------------------------------------------
// 2. Parse the DSL from KeyboardLayoutData.swift
// ---------------------------------------------------------------------------
function parseDsl(source) {
  const blocks = [];
  // Each block is a Swift multi-line string literal between """ lines.
  const re = /\n[ \t]*"""\n([\s\S]*?)\n[ \t]*""",?(?=\n)/g;
  let m;
  while ((m = re.exec(source)) !== null) {
    const raw = m[1];
    // Trim per-line indentation and blank padding.
    const lines = raw.split('\n')
      .map((l) => l.replace(/\r$/, '').replace(/^[ \t]{1,4}/, '').trimEnd());
    if (lines.length < 2) continue;
    const name = lines[0].trim();
    const rows = lines.slice(1).filter((r) => r.length > 0);
    // Only treat as a keyboard layout if it has 1–4 non-empty rows and rows
    // contain mostly printable single chars. (Descriptions live in a different
    // function body and won't match this shape.)
    if (rows.length === 0 || rows.length > 4) continue;
    blocks.push({ name, rows });
  }
  return blocks;
}

// ---------------------------------------------------------------------------
// 3. Parse descriptions from the allLayouts() function body
// ---------------------------------------------------------------------------
function parseDescriptions(source) {
  const descriptions = [];
  // Find the body inside allLayouts() — from "return [" to the closing "]}"
  const start = source.indexOf('static func allLayouts()', 0);
  const bodyOpen = source.indexOf('return [', start);
  if (start === -1 || bodyOpen === -1) return descriptions;
  const close = source.indexOf(']}', bodyOpen);
  const body = source.slice(bodyOpen, close === -1 ? source.length : close + 2);

  // Each entry: KeyboardLayoutInfo(name: "X", description: "Y")
  const re = /KeyboardLayoutInfo\(name:\s*"([^"]+)",\s*description:\s*"((?:[^"\\]|\\.)*)"\)/g;
  let m;
  while ((m = re.exec(body)) !== null) {
    descriptions.push({ name: m[1], description: m[2] });
  }
  return descriptions;
}

// ---------------------------------------------------------------------------
// 4. Merge into the canonical model
// ---------------------------------------------------------------------------
function canonicalize({ dslLayouts, statsEntries, descriptionEntries }) {
  const layoutsById = new Map();
  const metricsById = new Map();
  const descById = new Map();

  // First pass: every DSL layout gets a stable id (even if there is no metric).
  const seenName = new Map(); // normalised name -> id, to catch dups
  for (const block of dslLayouts) {
    const id = slugify(block.name);
    if (!id) continue;
    if (seenName.has(id)) {
      // Duplicate slug — disambiguate deterministically.
      let n = 2;
      let candidate = `${id}-${n}`;
      while (seenName.has(candidate)) { n++; candidate = `${id}-${n}`; }
      seenName.set(id, candidate);
    }
    seenName.set(id, id);
    layoutsById.set(id, {
      id,
      name: block.name,
      rows: block.rows.map((r) => Array.from(r)), // grapheme-aware enough for ASCII-ish
    });
  }

  // Second pass: join JSON geometry + metrics onto ids by normalised-name match.
  for (const entry of statsEntries) {
    const key = normalizeForMatch(entry.name);
    // Find the layout whose *normalised DSL block name* matches.
    let matchedId = null;
    for (const [id, layout] of layoutsById) {
      if (normalizeForMatch(layout.name) === key) { matchedId = id; break; }
    }
    if (!matchedId) continue; // JSON entry with no renderable layout — skip (coverage report below)

    const layout = layoutsById.get(matchedId);
    // Prefer the JSON's authoritative variable-width geometry; but keep the
    // DSL name as the display name (cleaner).
    if (entry.layout && entry.layout.length > 0) {
      layout.rows = entry.layout.map((row) => row.map((c) => String(c)));
    }
    // Strip the analyser suffix out of the JSON name, keep it as provenance.
    const analog = entry.name.match(/\(([^)]+)\)\s*$/);
    const analyser = analog ? analog[1] : null;
    metricsById.set(matchedId, {
      layoutId: matchedId,
      analyser,
      corpus: null, // unrecorded in legacy data — see DOMAIN.md R-10
      measuredAt: null,
      likes: entry.likes,
      stats: {
        alt: entry.stats.alt,
        roll: entry.stats.roll,
        one: entry.stats.one,
        rtl: entry.stats.rtl,
        red: entry.stats.red,
        sfb: entry.stats.sfb,
        sfs: entry.stats.sfs,
        lh: entry.stats.lh,
        rh: entry.stats.rh,
      },
    });
  }

  // Third pass: join descriptions.
  for (const d of descriptionEntries) {
    const key = normalizeForMatch(d.name);
    let matchedId = null;
    for (const [id, layout] of layoutsById) {
      if (normalizeForMatch(layout.name) === key) { matchedId = id; break; }
    }
    if (!matchedId) continue;
    descById.set(matchedId, {
      layoutId: matchedId,
      description: d.description,
    });
  }

  return { layoutsById, metricsById, descById };
}

// ---------------------------------------------------------------------------
// 5. Validation + summary + write
// ---------------------------------------------------------------------------
function validate({ layoutsById, metricsById, descById }) {
  const errors = [];
  const ids = new Set(layoutsById.keys());

  // V-1: unique ids — guaranteed by Map, but assert.
  if (ids.size !== layoutsById.size) errors.push('duplicate layout ids');

  // V-2: every metric/description FK resolves.
  for (const [id] of metricsById) if (!ids.has(id)) errors.push(`metric FK unresolved: ${id}`);
  for (const [id] of descById) if (!ids.has(id)) errors.push(`description FK unresolved: ${id}`);

  // V-3: non-empty rows, no phantom spaces.
  for (const [id, l] of layoutsById) {
    if (l.rows.length === 0) errors.push(`${id}: no rows`);
    for (const row of l.rows) {
      if (row.some((c) => c === ' ')) errors.push(`${id}: row contains a phantom space`);
    }
  }

  // V-4: row/height bounds — 3 or 4 rows typical; warn on unusual but don't hard-fail.
  for (const [id, l] of layoutsById) {
    if (l.rows.length > 4) errors.push(`${id}: unexpected row count ${l.rows.length}`);
  }

  // V-5: lh + rh == 100 ± 0.5
  for (const [id, m] of metricsById) {
    const { lh, rh } = m.stats;
    if (Math.abs(lh + rh - 100) > 0.5) {
      errors.push(`${id}: lh+rh=${lh + rh} (expected ~100)`);
    }
  }

  return errors;
}

function main() {
  if (!fs.existsSync(DSL_PATH)) {
    console.error('Could not find KeyboardLayoutData.swift at', DSL_PATH);
    process.exit(1);
  }
  if (!fs.existsSync(STATS_PATH)) {
    console.error('Could not find KeyboardStats.json at', STATS_PATH);
    process.exit(1);
  }

  const dslSource = fs.readFileSync(DSL_PATH, 'utf8');
  const dslLayouts = parseDsl(dslSource);
  const descriptions = parseDescriptions(dslSource);
  const statsEntries = JSON.parse(fs.readFileSync(STATS_PATH, 'utf8'));

  const { layoutsById, metricsById, descById } = canonicalize({
    dslLayouts,
    statsEntries,
    descriptionEntries: descriptions,
  });

  const errors = validate({ layoutsById, metricsById, descById });
  if (errors.length > 0) {
    console.error('VALIDATION FAILED:');
    errors.forEach((e) => console.error('  ✗ ' + e));
    process.exit(1);
  }

  const layouts = [...layoutsById.values()].sort((a, b) => a.name.localeCompare(b.name));
  const metrics = [...metricsById.values()].sort((a, b) => a.layoutId.localeCompare(b.layoutId));
  const descList = [...descById.values()].sort((a, b) => a.layoutId.localeCompare(b.layoutId));

  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(path.join(OUT_DIR, 'layouts.json'), JSON.stringify(layouts, null, 2));
  fs.writeFileSync(path.join(OUT_DIR, 'metrics.json'), JSON.stringify(metrics, null, 2));
  fs.writeFileSync(path.join(OUT_DIR, 'descriptions.json'), JSON.stringify(descList, null, 2));

  // Coverage report (V-7 style, warning not failure).
  const withMetric = new Set(metrics.map((m) => m.layoutId));
  const withDesc = new Set(descList.map((d) => d.layoutId));
  const noMetric = layouts.filter((l) => !withMetric.has(l.id)).length;
  const noDesc = layouts.filter((l) => !withDesc.has(l.id)).length;

  console.log('=== Keylapp 2.0 canonical data migration ===');
  console.log(`Layouts written:        ${layouts.length}`);
  console.log(`Metric sets written:    ${metrics.length}`);
  console.log(`Descriptions written:   ${descList.length}`);
  console.log(`Layouts w/o metrics:    ${noMetric}`);
  console.log(`Layouts w/o description:${noDesc}`);
  console.log('Files: assets/data/layouts.json, metrics.json, descriptions.json');
  if (noMetric > 0 || noDesc > 0) {
    console.warn('⚠️  Content gaps exist (they render as "no data" states — by design).');
  }
}

main();