import { expect, test } from "bun:test";
import { greet } from "./index.ts";

test("greets plainly by default", () => {
  expect(greet("Ada").text).toBe("Hello, Ada.");
});

test("greets with excitement when asked", () => {
  expect(greet("Ada", "excited").text).toBe("Hello, Ada!");
});
