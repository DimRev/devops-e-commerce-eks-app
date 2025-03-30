import { Button } from '~/features/shared/components/ui/button';
import { useLogin } from '../hooks/useLogin';

function AuthButtons() {
  const {
    mutateAsync: asyncLogin,
    isPending: isLoginPending,
    isError: isLoginError,
    error: loginError,
  } = useLogin();

  async function handleLogin() {
    await asyncLogin(
      { email: 'dev@dimrev.xyz', password: '123456' },
      {
        onError: (err) => {
          console.error(err.consoleMessage);
        },
        onSuccess: (data) => {
          console.log(data);
        },
      }
    );
  }

  return (
    <>
      <Button onClick={handleLogin} disabled={isLoginPending}>
        Login
      </Button>
      {isLoginPending && <div>Loading...</div>}
      {isLoginError && <div>{loginError.uiMessage}</div>}
    </>
  );
}

export default AuthButtons;
