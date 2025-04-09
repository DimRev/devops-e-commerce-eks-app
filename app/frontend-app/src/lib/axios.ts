import axios from 'axios';
import { AppConfig } from './globals';

const config = AppConfig.getInstance();

const routes = {
  auth: `${config.apiUrl}/v1/auth`,
};

export const ROUTES = {
  AUTH: axios.create({
    baseURL: routes.auth,
  }),
};

export type CustomAxiosError = {
  message: string;
};
