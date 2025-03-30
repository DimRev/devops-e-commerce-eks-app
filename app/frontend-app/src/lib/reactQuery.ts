import { AxiosError } from 'axios';
import { ZodError } from 'zod';

export enum ReactQueryErrorTypes {
  AXIOS = 'AXIOS',
  ZOD = 'ZOD',
  GENERAL = 'GENERAL',
  UNKNOWN = 'UNKNOWN',
}

export interface CustomAxiosError {
  message: string;
}

// QUERY_KEYS = {

// } as const

export class ReactQueryCustomError extends Error {
  type: ReactQueryErrorTypes;
  uiMessage: string;
  consoleMessage: string;

  constructor(originalError: unknown) {
    const { name, consoleMessage, uiMessage, stack, type } =
      ReactQueryCustomError.formatError(originalError);
    super(consoleMessage);
    this.name = name;
    this.stack = stack;
    this.type = type;
    this.consoleMessage = consoleMessage;
    this.uiMessage = uiMessage;

    // Optionally capture stack trace for V8 environments
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, ReactQueryCustomError);
    }
  }

  private static formatError(originalError: unknown): {
    name: string;
    consoleMessage: string;
    uiMessage: string;
    stack?: string;
    type: ReactQueryErrorTypes;
  } {
    let name: string;
    let consoleMessage: string;
    let uiMessage: string;
    let stack: string | undefined;
    let type: ReactQueryErrorTypes;

    if (originalError instanceof AxiosError) {
      name = originalError.name;
      stack = originalError.stack;
      type = ReactQueryErrorTypes.AXIOS;
      if (originalError.response) {
        const { config, status, statusText, data } = originalError.response;
        const method = config.method?.toUpperCase() || 'UNKNOWN';
        const url = config.url || 'unknown URL';
        const detailedMessage = `Axios Error [${method} ${url}]: ${status} ${
          statusText || ''
        } - ${
          (data as CustomAxiosError)?.message || originalError.message
        }`.trim();
        consoleMessage = detailedMessage;
        uiMessage = 'A network error occurred. Please try again later.';
      } else if (originalError.request) {
        consoleMessage = `Axios Error: Request sent but no response received for ${
          originalError.config?.url || 'unknown URL'
        }.`;
        uiMessage = 'A network error occurred. Please try again later.';
      } else {
        consoleMessage = `Axios Error: ${originalError.message}`;
        uiMessage = 'A network error occurred. Please try again later.';
      }
    } else if (originalError instanceof ZodError) {
      name = originalError.name;
      stack = originalError.stack;
      type = ReactQueryErrorTypes.ZOD;
      // Build a detailed message including all issues with their respective paths.
      const formattedIssues = originalError.errors
        .map((issue) => {
          const path = issue.path.length > 0 ? issue.path.join('.') : 'value';
          return `${path}: ${issue.message}`;
        })
        .join('; ');
      consoleMessage = `Zod Error: Validation failed. ${formattedIssues}`;
      uiMessage = 'Invalid input. Please check your data.';
    } else if (originalError instanceof Error) {
      name = originalError.name;
      stack = originalError.stack;
      consoleMessage = originalError.message;
      uiMessage = 'An error occurred. Please try again.';
      type = ReactQueryErrorTypes.GENERAL;
    } else {
      name = 'Unknown Error';
      consoleMessage = 'Unknown Error: An undocumented error occurred.';
      uiMessage = 'An unexpected error occurred.';
      type = ReactQueryErrorTypes.UNKNOWN;
    }

    return { name, consoleMessage, uiMessage, stack, type };
  }
}
