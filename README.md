# Energinet-CI-CD-Case
A job interview case for position in Energinet



Case:

CI/CD pipeline and infrastructure deployment 
- Outline the strategy for setting up a CI/CD pipeline, detailing the process for automated build, testing, and deployment. Explain the decision-making process for tool selection and the approach to ensure efficient, reliable pipeline operations.
- Explain the integration of Infrastructure as Code (IaC) into a CI/CD pipeline for provisioning infrastructure automatically before deploying application updates.

initial CI/CD pipeline plan
I have created a flow chart detailing a CI/CD setup. This flow puts a lot of prioritization on testing, both on the developers side and on remote side. Read more below the figure.

![](/assets/CICD%20pipeline%20flow.drawio.svg)




Commit stage:
Using a git hook on the client side we can automatically trigger unit tests for the system and reject the commit if the tests doesn't pass.
Depending on the testing framework of choice, we can decide if we want to run a full test suite for to verify our entire code coverage, or we can limit the tests to the files changed in the latest commit. Smoke tests is also viable.

Build stage:
Builder of our choice is started to build any desired artifact used for deployment of this servioce .I am mostly confident with jenkins at this stage, but a lot of Repository services have a pipeline plugin for executing these following steps. In my experience they're often scripted in YAML, or yaml-like language.

When the build has succeeded, the artifact can be pushed to artifact registry. For Docker images, there exists a plethora of repo services to store them in.

Verification and validation stage:
Full component tests, integration tests and Acceptances tests suites are run at this stage.
If manual validation is part of the release process, then this is also an appropriate stage for gating the release until the manual validation is done succefully.

Deployment stage:
Here we deploy our revision. If we have any staging or development environments, then this revision of our service should be deployed here.
Given the deployments on the aforementioned environments were successful, we could also decide here to deploy to production.
It is at this stage that Infrastructure as Code makes it's significance. If we have a critical service exposed to our stakeholders, then it is crucial to know which configurations of our service as working as intended. IaC allows for automation, And importantly it also allows for configuration versioning.
With versioning, we can always keep a history of the state of our product, and be able to revisit a specific state. This enables easy rollbacks, in case of failures, and more deterministic statefulness, as well as more information stored to troubleshoot with.

We can keep this configuration as part of the source code repo for our product, or we can contain them in a separate git repo, perhaps when we want to facilitate a microservices architecture. We can then keep state versioning on all our microservices at any given time.




__________________________________
This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/basic-features/font-optimization) to automatically optimize and load Inter, a custom Google Font.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.
