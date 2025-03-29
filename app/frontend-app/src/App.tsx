function App() {
  const env = window.__ENV__ || {
    ENV: 'N/A',
    APP_NAME: 'N/A',
    API_URL: 'N/A',
    VERSION: 'N/A',
  };

  if (!env) {
    console.error('No environment variables found');

    return (
      <>
        <h1>No environment variables found</h1>
      </>
    );
  }

  return (
    <>
      <div className="h-dvh w-dvw flex flex-col">
        <header className="h-10 flex justify-center items-center border-b">
          <div className="container  flex h-full items-center justify-between">
            <div>Logo</div>
            <nav>
              <ul className="flex items-center gap-x-4">
                <li>
                  <a href="/" className="">
                    Home
                  </a>
                </li>
                <li>
                  <a href="/about" className="">
                    About
                  </a>
                </li>
                <li>
                  <a href="/contact" className="">
                    Contact
                  </a>
                </li>
              </ul>
            </nav>
          </div>
        </header>
        <main className="flex-1 border flex flex-col items-center justify-center">
          <div className="container flex-1">
            <h1 className="text-4xl font-bold">
              Welcome to the {env.APP_NAME} app
            </h1>
            <p>
              This is a simple app to demonstrate how to use the frontend app
            </p>
          </div>
        </main>
        <footer className="h-5  flex justify-center items-center">
          <p className="text-xs font-extrabold">
            {env.ENV} - {env.APP_NAME} - {env.VERSION}
          </p>
        </footer>
      </div>
    </>
  );
}

export default App;
