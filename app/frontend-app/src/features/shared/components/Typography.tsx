import { forwardRef, HTMLAttributes } from 'react';
import { cn } from '~/lib/utils';

const H1 = forwardRef<HTMLHeadingElement, HTMLAttributes<HTMLHeadingElement>>(
  ({ className, children, ...props }, ref) => (
    <h1 ref={ref} className={cn('text-4xl font-bold', className)} {...props}>
      {children}
    </h1>
  )
);
H1.displayName = 'H1';

const H2 = forwardRef<HTMLHeadingElement, HTMLAttributes<HTMLHeadingElement>>(
  ({ className, children, ...props }, ref) => (
    <h2 ref={ref} className={cn('text-3xl font-bold', className)} {...props}>
      {children}
    </h2>
  )
);
H2.displayName = 'H2';

const H3 = forwardRef<HTMLHeadingElement, HTMLAttributes<HTMLHeadingElement>>(
  ({ className, children, ...props }, ref) => (
    <h3 ref={ref} className={cn('text-2xl font-bold', className)} {...props}>
      {children}
    </h3>
  )
);
H3.displayName = 'H3';

const H4 = forwardRef<HTMLHeadingElement, HTMLAttributes<HTMLHeadingElement>>(
  ({ className, children, ...props }, ref) => (
    <h4 ref={ref} className={cn('text-xl font-bold', className)} {...props}>
      {children}
    </h4>
  )
);
H4.displayName = 'H4';

const H5 = forwardRef<HTMLHeadingElement, HTMLAttributes<HTMLHeadingElement>>(
  ({ className, children, ...props }, ref) => (
    <h5 ref={ref} className={cn('text-lg font-bold', className)} {...props}>
      {children}
    </h5>
  )
);
H5.displayName = 'H5';

const H6 = forwardRef<HTMLHeadingElement, HTMLAttributes<HTMLHeadingElement>>(
  ({ className, children, ...props }, ref) => (
    <h6 ref={ref} className={cn('text-lg font-bold', className)} {...props}>
      {children}
    </h6>
  )
);
H6.displayName = 'H6';

const P = forwardRef<
  HTMLParagraphElement,
  HTMLAttributes<HTMLParagraphElement>
>(({ className, children, ...props }, ref) => (
  <p ref={ref} className={cn('text-base', className)} {...props}>
    {children}
  </p>
));
P.displayName = 'P';

export { H1, H2, H3, H4, H5, H6, P };
