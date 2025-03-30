import { useMutation } from '@tanstack/react-query';
import { AxiosResponse } from 'axios';
import { ROUTES } from '~/lib/axios';
import { ReactQueryCustomError } from '~/lib/reactQuery';
import { LoginBody, LoginBodySchema, MiniUser } from '../schema/auth.schema';

async function login(loginBody: LoginBody) {
  try {
    const validLoginBody = LoginBodySchema.parse(loginBody);
    const resp = ROUTES.AUTH.post<MiniUser, AxiosResponse<MiniUser>, LoginBody>(
      '/login',
      validLoginBody
    );
    return (await resp).data;
  } catch (error: unknown) {
    const rqErr = new ReactQueryCustomError(error);
    console.error(rqErr.consoleMessage);
    throw rqErr;
  }
}

export function useLogin() {
  return useMutation<MiniUser, ReactQueryCustomError, LoginBody>({
    mutationFn: login,
  });
}
