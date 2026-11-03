import { createHash } from 'node:crypto';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';

const upstream = JSON.parse(readFileSync('moda/upstream.json', 'utf8'));
const tag = process.env.GITHUB_REF_NAME;
const sourceCommit = process.env.GITHUB_SHA;
const prefix = `v${upstream.version}-moda.`;
if (!tag?.startsWith(prefix) || !/^\d+$/.test(tag.slice(prefix.length))
    || !/^[0-9a-f]{40}$/.test(sourceCommit ?? '')) {
    throw new Error('Expected an internal release tag for this upstream version');
}
const sha256 = bytes => createHash('sha256').update(bytes).digest('hex');
const version = tag.slice(1);
const file = 'opencv-min.js';
const bytes = readFileSync(`moda/${file}`);
if (sha256(bytes) !== readFileSync('moda/opencv-min.sha256', 'utf8').trim()) {
    throw new Error('OpenCV bytes differ from the approved build');
}
mkdirSync('dist', { recursive: true });
writeFileSync(`dist/${file}`, bytes);
writeFileSync('dist/release-manifest.json', JSON.stringify({
    repository: process.env.GITHUB_REPOSITORY, tag, sourceCommit,
    name: upstream.name, version, file, sha256: sha256(bytes),
    upstreamVersion: upstream.version, upstreamCommit: upstream.gitHead,
    upstreamIntegrity: upstream.dist?.integrity,
}, null, 2) + '\n');
