import AppFooter from './features/layout/components/AppFooter';
import AppHeader from './features/layout/components/AppHeader';
import { BrowserRouter, Route, Routes } from 'react-router';
import HomePage from './features/view/components/HomePage';
import AboutPage from './features/view/components/AboutPage';
import ContactPage from './features/view/components/ContactPage';
import { defaultEnv } from './lib/globals';

function App() {
  const env = window.__ENV__ || defaultEnv;

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
      <BrowserRouter>
        <div className="h-dvh w-dvw flex flex-col">
          <AppHeader />
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/about" element={<AboutPage />} />
            <Route path="/contact" element={<ContactPage />} />
          </Routes>
          <AppFooter env={env} />
        </div>
      </BrowserRouter>
    </>
  );
}

export default App;
