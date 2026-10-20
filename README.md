# publishing-fixture

A throwaway repository for testing a package publishing pipeline end to end. It holds no
product code.

## Layout

- `packages/sdk` is the published package, `@elite-truck/publishing-fixture-sdk`. Packing it runs
  `prepack`, which bundles `src/index.ts` with Bun and writes type declarations with `tsc`.
- `packages/shapes` is a private workspace package. The SDK imports it by path, so its code
  ships inside the SDK.
- `.changeset/` holds change files, written with `bunx changeset`.
- `apps/api/.env.preproduction` is a stand-in for an app's committed settings. It exists so a
  push can change only a dotfile.

## Working on it

Use Bun 1.3.14.

```sh
bun install --frozen-lockfile
bun run type-check
bun test
bun run build:sdk
```

A pull request that changes what the SDK ships needs a change file: run `bunx changeset` and
commit the file it writes. A bot opens the "Release packages" pull request that sets versions
and changelogs. Don't edit `version` or `CHANGELOG.md` yourself.

A docs-only line for the dev run.
