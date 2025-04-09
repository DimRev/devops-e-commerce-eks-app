import { AppConfig } from '~/lib/globals';

const config = AppConfig.getInstance();

function AppFooter() {
  return (
    <footer className="h-5  flex justify-center items-center">
      <p className="text-xs font-extrabold">
        {config.env} - {config.appName} - {config.appVersion} - {config.apiUrl}
      </p>
    </footer>
  );
}

export default AppFooter;
