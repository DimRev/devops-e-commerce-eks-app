import PageLayout from '~/features/layout/components/PageLayout';
import { H1, P } from '~/features/shared/components/Typography';

function HomePage() {
  return (
    <PageLayout>
      <H1>Home Page</H1>
      <P>This is the home page</P>
    </PageLayout>
  );
}

export default HomePage;
