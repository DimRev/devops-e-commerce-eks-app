interface Env {
  ENV: string;
  APP_NAME: string;
  API_URL: string;
  VERSION: string;
}

declare global {
  interface Window {
    __ENV__?: Env;
  }
}

export { Env };
