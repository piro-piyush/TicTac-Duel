
import { mkdir, writeFile } from 'node:fs/promises';

const fingerprint = process.env.ANDROID_SHA256;

if (!fingerprint) {
  throw new Error('Missing ANDROID_SHA256 environment variable');
}

const fingerprints = fingerprint
  .split(',')
  .map((value) => value.trim().toUpperCase());

for (const value of fingerprints) {
  if (!/^([A-F0-9]{2}:){31}[A-F0-9]{2}$/.test(value)) {
    throw new Error(`Invalid SHA-256 fingerprint: ${value}`);
  }
}

const assetLinks = [
  {
    relation: ['delegate_permission/common.handle_all_urls'],
    target: {
      namespace: 'android_app',
      package_name: 'com.piyush.tictacduel',
      sha256_cert_fingerprints: fingerprints,
    },
  },
];

const directoryPath = 'web/.well-known';
const outputPath = `${directoryPath}/assetlinks.json`;

// Create the directory if it doesn't exist.
await mkdir(directoryPath, { recursive: true });

// Create the file or overwrite its existing contents.
await writeFile(
  outputPath,
  `${JSON.stringify(assetLinks, null, 2)}\n`,
  'utf8',
);

console.log(`Successfully generated ${outputPath}`);
console.log(`Configured ${fingerprints.length} certificate fingerprint(s).`);
