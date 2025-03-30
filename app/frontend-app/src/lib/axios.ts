import axios from 'axios';
import { defaultEnv } from './globals';

const env = window.__ENV__ || defaultEnv;

const routes = {
  auth: `${env.API_URL}/v1/auth`,
};

export const ROUTES = {
  AUTH: axios.create({
    baseURL: routes.auth,
  }),
};

export type CustomAxiosError = {
  message: string;
};
