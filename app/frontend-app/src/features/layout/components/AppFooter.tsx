import { Env } from '~/globals';

type Props = {
  env: Env;
};

function AppFooter({ env }: Props) {
  return (
    <footer className="h-5  flex justify-center items-center">
      <p className="text-xs font-extrabold">
        {env.ENV} - {env.APP_NAME} - {env.VERSION}
      </p>
    </footer>
  );
}

export default AppFooter;
