import { z } from 'zod';

export const LoginBodySchema = z.object({
  email: z.string().email(),
  password: z.string(),
});

export type LoginBody = z.infer<typeof LoginBodySchema>;

export type MiniUser = {
  username: string;
  email: string;
};

export const RegisterBodySchema = z.object({
  email: z.string().email(),
  username: z.string().min(3),
  password: z.string().refine((val) => {
    if (val.length < 8) {
      return false;
    }
    /**
     * Check if the password contains:
     * At least one uppercase letter,
     * one lowercase letter,
     * one number,
     * and one special character
     */
    const regex = new RegExp(
      '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})'
    );
    if (!regex.test(val)) {
      return false;
    }
    return true;
  }, 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character'),
});

export type RegisterBody = z.infer<typeof RegisterBodySchema>;
