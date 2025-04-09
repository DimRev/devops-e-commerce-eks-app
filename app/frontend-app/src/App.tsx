import AppFooter from './features/layout/components/AppFooter';
import AppHeader from './features/layout/components/AppHeader';
import { BrowserRouter, Route, Routes } from 'react-router';
import HomePage from './features/view/components/HomePage';
import AboutPage from './features/view/components/AboutPage';
import ContactPage from './features/view/components/ContactPage';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

const queryClient = new QueryClient();

function App() {
  return (
    <>
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>
          <div className="h-dvh w-dvw flex flex-col">
            <AppHeader />
            <Routes>
              <Route path="/" element={<HomePage />} />
              <Route path="/about" element={<AboutPage />} />
              <Route path="/contact" element={<ContactPage />} />
            </Routes>
            <AppFooter />
          </div>
        </BrowserRouter>
      </QueryClientProvider>
    </>
  );
}

export default App;
