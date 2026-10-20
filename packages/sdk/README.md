# Publishing fixture SDK

A tiny package for testing a package publishing pipeline. It greets people.

```ts
import { greet } from "@elite-truck/publishing-fixture-sdk";

greet("Ada").text; // "Hello, Ada."
greet("Ada", "excited").text; // "Hello, Ada!"
```

## Changing the SDK

A pull request that changes what this package ships needs a change file. That includes this
README and `packages/shapes`, which the build bundles. From the repository root, run
`bunx changeset`, pick a bump (patch for a fix, minor for something new, major for a breaking
change) and write one line for the changelog. Never edit `version` or `CHANGELOG.md` by hand.
