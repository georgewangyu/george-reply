# Security review

This fork is intended for a single-owner Instagram automation deployment.

## 2026-09-05 baseline

- Updated dependencies within the repository's declared semver ranges.
- Removed the critical Auth.js advisories reported by `npm audit` at fork time.
- Changed production sign-in to fail closed unless `ALLOWED_EMAILS` contains the user.
- Kept secrets server-side and out of version control.

`npm audit --omit=dev` still reports high-severity findings inherited through
Auth.js/Nodemailer and Prisma's dependency graph. Do not treat this repository
as production-approved until those findings have been reviewed, mitigated, or
explicitly accepted and the deployment has been tested with non-production
Instagram credentials.

Run this before each deployment:

```bash
npm ci
npm audit --omit=dev
npm test
npm run typecheck
npm run lint
npm run build
```
