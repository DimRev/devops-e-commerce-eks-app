import { NavLink } from 'react-router';
import AuthButtons from '~/features/auth/components/AuthButtons';
import { buttonVariants } from '~/features/shared/components/ui/button';
import { cn } from '~/lib/utils';

function AppHeader() {
  return (
    <header className="h-10 flex justify-center items-center border-b">
      <div className="container  flex h-full items-center justify-between">
        <div>Logo</div>
        <nav>
          <div className="flex items-center gap-x-4">
            <NavLink
              to="/"
              className={({ isActive }) =>
                cn(
                  buttonVariants({ variant: 'link' }),
                  isActive && 'underline text-green-600'
                )
              }
            >
              Home
            </NavLink>
            <NavLink
              to="/about"
              className={({ isActive }) =>
                cn(
                  buttonVariants({ variant: 'link' }),
                  isActive && 'underline text-green-600'
                )
              }
            >
              About
            </NavLink>
            <NavLink
              to="/contact"
              className={({ isActive }) =>
                cn(
                  buttonVariants({ variant: 'link' }),
                  isActive && 'underline text-green-600'
                )
              }
            >
              Contact
            </NavLink>
            <AuthButtons />
          </div>
        </nav>
      </div>
    </header>
  );
}

export default AppHeader;
