export class AppConfig {
  private static instance: AppConfig | null = null;

  public readonly env: string;
  public readonly appName: string;
  public readonly apiUrl: string;
  public readonly appVersion: string;

  constructor() {
    this.env = this.getRequiredValue('ENV', import.meta.env.VITE_APP_ENV);
    this.appName = this.getRequiredValue(
      'APP_NAME',
      import.meta.env.VITE_APP_NAME
    );
    this.apiUrl = this.getRequiredValue(
      'API_URL',
      import.meta.env.VITE_API_URL
    );
    this.appVersion = this.getRequiredValue(
      'VERSION',
      import.meta.env.VITE_APP_VERSION
    );
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  private getRequiredValue(name: string, value: any): string {
    if (value !== null && value !== undefined && value !== '') {
      return value;
    }
    throw new Error(
      `Required configuration value "${name}" is not set. Check your .env files.`
    );
  }

  public static getInstance(): AppConfig {
    if (!AppConfig.instance) {
      AppConfig.instance = new AppConfig();
    }
    return AppConfig.instance;
  }

  public isProduction(): boolean {
    return this.env === 'production';
  }

  public isDevelopment(): boolean {
    return this.env === 'development';
  }

  public isTest(): boolean {
    return this.env === 'test';
  }
}

export default AppConfig.getInstance();
