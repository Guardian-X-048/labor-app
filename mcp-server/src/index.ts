import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { z } from "zod";

const server = new Server(
  {
    name: "laborlinks-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "echo",
        description: "Return the same message you send.",
        inputSchema: {
          type: "object",
          properties: {
            message: { type: "string", description: "Message to echo" },
          },
          required: ["message"],
          additionalProperties: false,
        },
      },
      {
        name: "get_time",
        description: "Get current server time in ISO format.",
        inputSchema: {
          type: "object",
          properties: {},
          additionalProperties: false,
        },
      },
      {
        name: "job_quote",
        description: "Generate a rough labor quote based on category and hours.",
        inputSchema: {
          type: "object",
          properties: {
            category: {
              type: "string",
              enum: ["plumbing", "electrical", "cleaning", "painting", "carpentry"],
              description: "Service category",
            },
            hours: { type: "number", minimum: 1, maximum: 24, description: "Estimated hours" },
          },
          required: ["category", "hours"],
          additionalProperties: false,
        },
      },
    ],
  };
});

const quoteInputSchema = z.object({
  category: z.enum(["plumbing", "electrical", "cleaning", "painting", "carpentry"]),
  hours: z.number().min(1).max(24),
});

const baseRates: Record<string, number> = {
  plumbing: 450,
  electrical: 500,
  cleaning: 300,
  painting: 400,
  carpentry: 550,
};

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === "echo") {
    const message = z.object({ message: z.string() }).parse(args).message;
    return {
      content: [{ type: "text", text: message }],
    };
  }

  if (name === "get_time") {
    return {
      content: [{ type: "text", text: new Date().toISOString() }],
    };
  }

  if (name === "job_quote") {
    const input = quoteInputSchema.parse(args);
    const rate = baseRates[input.category];
    const total = rate * input.hours;

    return {
      content: [
        {
          type: "text",
          text: `Estimated quote for ${input.category}: INR ${total} (${input.hours}h x INR ${rate}/h)`,
        },
      ],
    };
  }

  return {
    content: [{ type: "text", text: `Unknown tool: ${name}` }],
    isError: true,
  };
});

async function main(): Promise<void> {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  console.error("MCP server failed to start:", error);
  process.exit(1);
});
