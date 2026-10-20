export type GreetingStyle = "plain" | "excited";

export interface Greeting {
  readonly name: string;
  readonly style: GreetingStyle;
  readonly text: string;
}

export function greetingText(name: string, style: GreetingStyle): string {
  return style === "excited" ? `Hello, ${name}!` : `Hello, ${name}.`;
}
