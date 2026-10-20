import { type Greeting, type GreetingStyle, greetingText } from "../../shapes/src/greeting.ts";

export type { Greeting, GreetingStyle };

export function greet(name: string, style: GreetingStyle = "plain"): Greeting {
  return { name, style, text: greetingText(name, style) };
}
