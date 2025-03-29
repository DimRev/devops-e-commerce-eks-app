import { PropsWithChildren } from 'react';

function PageLayout({ children }: PropsWithChildren) {
  return (
    <main className="flex-1 border flex flex-col items-center justify-center">
      <div className="container flex-1">{children}</div>
    </main>
  );
}

export default PageLayout;
