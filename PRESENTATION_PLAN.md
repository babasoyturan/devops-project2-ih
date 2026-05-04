# Burger Builder Presentation Plan

This document is the detailed, slide-by-slide plan for the Burger Builder project presentation. It is designed for mixed technical and non-technical stakeholders and is based on the implementation currently present in this repository.

## Deck Profile

- Recommended deck length: 14 slides
- Recommended presentation length: 12 to 15 minutes
- Audience: CEO, senior leadership, managers, engineers, and business stakeholders
- Tone: business-first, executive-friendly, technically credible, balanced and candid
- Core message: this project is not only a web app deployment; it is a shift from manual operations to an automated, more secure, repeatable delivery platform

---

## Slide 1 - Burger Builder DevOps Platform

- Slide number: 1
- Slide title: Burger Builder DevOps Platform
- Main message of the slide: Introduce the project as a production-style DevOps transformation, not just an application demo.
- Exact text to place on the slide:

```text
Burger Builder DevOps Platform

From manual setup to a secure, automated Azure delivery platform

Presented by: [Name 1], [Name 2], [Name 3], [Name 4]
```

- Key bullet points to include:
  - Full-stack burger ordering application
  - Automated Azure infrastructure and deployments
  - Secure public access with HTTPS and controlled routing
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Clean title slide with a simple cloud platform illustration and small callouts for `burgerapp.live` and `dev.burgerapp.live`
- Recommended visual layout:
  - Full-width title at the top
  - Subtitle centered underneath
  - Presenter names in a bottom footer
  - Right-side hero visual with cloud, lock, pipeline, and browser icons
- Speaker notes:
  - Open with the business framing: this project was about building an application and the operating model behind it.
  - Explain that the audience will see both the business value and the technical implementation.
  - Keep the introduction short and confident.
- Business value connection:
  - Positions the project as an enabler of speed, security, and operational maturity.
- Technical depth level: Low

---

## Slide 2 - Project Overview

- Slide number: 2
- Slide title: Project Overview
- Main message of the slide: The project addressed the business problem of fragile, manual delivery by creating a repeatable cloud deployment model.
- Exact text to place on the slide:

```text
Project Overview

Business problem:
Manual provisioning and manual deployments do not scale well

Project goal:
Deploy Burger Builder in secure, repeatable development and production environments

Outcome:
Faster delivery, lower operational risk, and stronger production readiness
```

- Key bullet points to include:
  - Burger Builder is a React frontend with a Spring Boot backend and Azure SQL database
  - The project focused on both product delivery and platform reliability
  - The platform now supports repeatable setup and repeatable releases
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Before vs after comparison showing manual setup on the left and automated platform on the right
- Recommended visual layout:
  - Two-column layout
  - Left column: business problem and goal
  - Right column: before vs after visual
- Speaker notes:
  - Explain the project in non-technical terms first.
  - Say that the problem was not writing the app alone; the problem was operating it safely and consistently.
  - For technical listeners, briefly mention that the solution includes infrastructure automation, deployment automation, and security controls.
- Business value connection:
  - Makes the project relevant to leadership by tying it to release speed, consistency, and lower human-error risk.
- Technical depth level: Low

---

## Slide 3 - Objectives and Learning Goals

- Slide number: 3
- Slide title: Objectives and Learning Goals
- Main message of the slide: The team set out to build both technical capability and production-style discipline.
- Exact text to place on the slide:

```text
Objectives and Learning Goals

Build secure and maintainable cloud environments
Automate infrastructure and deployments
Separate development and production safely
Use HTTPS, domains, and certificates correctly
Apply monitoring and production-style operational thinking
```

- Key bullet points to include:
  - Learn Infrastructure as Code with Terraform
  - Learn configuration and deployment automation with Ansible
  - Learn CI/CD orchestration with GitHub Actions
  - Learn secure traffic handling with Application Gateway, WAF, and TLS
  - Learn how environment separation reduces business risk
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Capability ladder or learning-objective pyramid
- Recommended visual layout:
  - Title at top
  - Five large objective blocks in the center
  - Small footer note: "Technical learning tied to business outcomes"
- Speaker notes:
  - Frame the learning goals as business-relevant skills, not classroom-only skills.
  - Explain that each goal connects to a business need: governance, speed, reliability, or trust.
  - Keep the wording simple and outcome-focused.
- Business value connection:
  - Shows why the learning objectives matter in a real company setting.
- Technical depth level: Low

---

## Slide 4 - Implementation Details: Architecture and Environment Separation

- Slide number: 4
- Slide title: Implementation Details: Architecture and Environment Separation
- Main message of the slide: The platform was built with controlled public access, private internal services, and clear separation between dev and prod.
- Exact text to place on the slide:

```text
Architecture and Environment Separation

One public application entry point
Private frontend, backend, and data services
Separate development and production environments
Lower-risk testing before production release
```

- Key bullet points to include:
  - Azure Application Gateway fronts the application
  - Frontend VM and backend VM use private IP addresses
  - Azure SQL is private and uses a private endpoint
  - Dev VNet: `10.60.0.0/16`
  - Prod VNet: `10.70.0.0/16`
  - Dev includes a SonarQube VM; prod does not
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Main architecture diagram with a dev vs prod environment comparison strip
- Recommended visual layout:
  - Large architecture diagram in the center
  - Bottom ribbon comparing dev and prod side by side
- Speaker notes:
  - Use the office-building analogy: one controlled entrance for visitors, private rooms inside, and restricted storage areas.
  - Explain that environment separation protects business continuity because changes can be tested in dev before they reach production.
  - Mention that dev uses a smaller footprint and prod uses stronger VM sizing, which supports cost-aware scaling.
- Business value connection:
  - Reduces production risk, improves change control, and supports more reliable releases.
- Technical depth level: Medium

---

## Slide 5 - Implementation Details: Automation and Deployment Flow

- Slide number: 5
- Slide title: Implementation Details: Automation and Deployment Flow
- Main message of the slide: The team automated both platform creation and application delivery to reduce manual work and improve repeatability.
- Exact text to place on the slide:

```text
Automation and Deployment Flow

Terraform provisions the platform
Ansible configures the servers
GitHub Actions orchestrates delivery
Azure Container Registry stores versioned images
```

- Key bullet points to include:
  - Shared, dev, and prod infrastructure are provisioned with Terraform
  - Ansible installs Docker and deploys the frontend and backend containers
  - Frontend and backend images are tagged by commit SHA
  - Branch flow maps `dev` to development and `main` to production
  - Frontend pipeline runs lint, tests, build, scan, push, and deploy
  - Backend pipeline builds, scans, validates Docker image creation, pushes, and deploys
- Picture idea, diagram idea, or screenshot idea for that slide:
  - CI/CD pipeline diagram showing `GitHub -> Actions -> ACR -> Ansible -> Azure VMs`
- Recommended visual layout:
  - Horizontal workflow diagram with icons and short labels
  - Small callout box for branch-to-environment mapping
- Speaker notes:
  - Use the analogy: Terraform is the blueprint, Ansible is the operations checklist, and GitHub Actions is the production line.
  - Explain that this matters because the same process can be repeated consistently.
  - Be precise if asked: frontend tests run automatically, while backend CI currently packages and scans but does not yet enforce automated test execution in the workflow.
- Business value connection:
  - Cuts repeated manual engineering effort, shortens release time, and makes recovery easier.
- Technical depth level: Medium

---

## Slide 6 - Challenges and Solutions: Secure Public Access

- Slide number: 6
- Slide title: Challenges and Solutions: Secure Public Access
- Main message of the slide: The team needed to make the application reachable from the internet without exposing internal systems directly.
- Exact text to place on the slide:

```text
Challenge: Make the application public without making the platform public

Solution:
Use Azure Application Gateway as the customer-facing entry point
Route traffic internally to private frontend and backend services
Protect user traffic with HTTPS
```

- Key bullet points to include:
  - Customer traffic enters through Azure Application Gateway WAF v2
  - `burgerapp.live` and `www.burgerapp.live` route to production
  - `dev.burgerapp.live` routes to development
  - `/api/*` routes to the backend while root traffic goes to the frontend
  - HTTP is redirected to HTTPS
  - Gateway health probes check `/` and `/actuator/health`
- Picture idea, diagram idea, or screenshot idea for that slide:
  - HTTPS and domain/subdomain traffic flow diagram
  - Optional browser lock screenshot idea
- Recommended visual layout:
  - Left: problem and solution text
  - Right: traffic-flow diagram with green approved paths and red blocked direct-access paths
- Speaker notes:
  - Explain that the architecture protects the platform by hiding the application servers behind the gateway.
  - Clarify one important detail: the Application Gateway is the public application entry point, while Azure Bastion has a separate public IP for controlled administrator access only.
  - Mention that the frontend was intentionally built to use same-origin browser traffic in deployed environments, so users stay on one domain and the gateway handles routing internally.
- Business value connection:
  - Improves security posture, keeps the user experience simple, and reduces the risk of exposed internal endpoints.
- Technical depth level: High

---

## Slide 7 - Challenges and Solutions: Secrets, Certificates, and Consistent Deployment

- Slide number: 7
- Slide title: Challenges and Solutions: Secrets, Certificates, and Consistent Deployment
- Main message of the slide: The team had to automate deployment while protecting sensitive data and reusing the same process across environments.
- Exact text to place on the slide:

```text
Challenge: Deploy consistently without hardcoding secrets

Solution:
Managed identities for Azure access
Key Vault for sensitive values
ACR permissions for image pulls
Certificate-based HTTPS at the gateway
```

- Key bullet points to include:
  - Application Gateway reads the certificate secret `cert-burgerapp-live` from Azure Key Vault
  - Frontend and backend VMs use `AcrPull` role assignments for Azure Container Registry
  - Backend VM uses `Key Vault Secrets User` to read database secrets
  - Ansible logs in with VM managed identity and pulls secrets at deployment time
  - Backend database credentials are written into a protected `.env` file on the host during deployment
  - Azure SQL requires TLS 1.2 and disables public network access
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Secret flow diagram: `VM managed identity -> Key Vault / ACR`
  - Optional Key Vault certificate screenshot idea
- Recommended visual layout:
  - Centered process diagram
  - Right-side security callout cards for Key Vault, certificate, and SQL
- Speaker notes:
  - Explain that this reduced the need for people to manually copy credentials or log in to servers for every release.
  - Keep the wording balanced: secrets are protected better than in a manual workflow, but the backend still materializes them into a local `.env` file, which is a future hardening opportunity.
  - Avoid calling the certificate wildcard unless the Azure portal confirms that exact certificate type.
- Business value connection:
  - Improves governance, reduces credential sprawl, and makes deployment less person-dependent.
- Technical depth level: High

---

## Slide 8 - Tools and Technologies: Application and Cloud Stack

- Slide number: 8
- Slide title: Tools and Technologies: Application and Cloud Stack
- Main message of the slide: The project uses a practical technology stack that supports maintainability, cloud deployment, and production-style delivery.
- Exact text to place on the slide:

```text
Application and Cloud Stack

Frontend: React, TypeScript, Vite, Nginx
Backend: Spring Boot, Java 21, Maven
Cloud: Azure VMs, Application Gateway WAF, Azure SQL, Key Vault, Bastion
Runtime: Docker containers
```

- Key bullet points to include:
  - React frontend serves static assets through Nginx
  - Spring Boot backend exposes REST APIs and health endpoints
  - Azure SQL provides managed database hosting
  - Application Gateway provides routing, WAF, and TLS termination
  - Azure Bastion supports controlled administrator access
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Tool ecosystem graphic grouped into `Application`, `Cloud`, and `Runtime`
- Recommended visual layout:
  - Three-column technology map with icons
  - Short one-line purpose under each tool group
- Speaker notes:
  - Do not read every tool name one by one.
  - Explain why these tools were chosen: mainstream, supportable, and suitable for a production-style setup.
  - For non-technical stakeholders, emphasize that managed cloud services reduce operational burden.
- Business value connection:
  - Shows that the solution is built on widely used technologies with good maintainability and hiring familiarity.
- Technical depth level: Medium

---

## Slide 9 - Tools and Technologies: Automation, Quality, and Observability

- Slide number: 9
- Slide title: Tools and Technologies: Automation, Quality, and Observability
- Main message of the slide: The second half of the stack is what turns a deployed app into an operable platform.
- Exact text to place on the slide:

```text
Automation, Quality, and Observability

Terraform = repeatable infrastructure
Ansible = repeatable server configuration
GitHub Actions = automated delivery workflow
SonarQube = code quality checks in development
Azure Monitor = visibility and alerting
```

- Key bullet points to include:
  - Terraform uses Azure remote state in a dedicated storage account and state container
  - GitHub Actions uses Azure OIDC login instead of static cloud credentials in the workflow
  - Ansible syntax checks run in the platform workflow
  - Dev includes SonarQube for quality scanning
  - Monitoring includes Log Analytics, Application Insights, and alert rules
  - Alerts cover unhealthy Application Gateway backend hosts, high VM CPU, and high SQL DTU consumption
- Picture idea, diagram idea, or screenshot idea for that slide:
  - GitHub Actions screenshot idea plus monitoring dashboard screenshot idea
- Recommended visual layout:
  - Left: tool-to-purpose matrix
  - Right: screenshot stack with GitHub Actions and Azure Monitor
- Speaker notes:
  - Explain that automation is not complete without visibility.
  - This is the slide where engineers will recognize the operational maturity steps: remote Terraform state, OIDC, scanning, and alerts.
  - For executives, keep the message simple: the platform can be built, updated, and watched in a disciplined way.
- Business value connection:
  - Helps reduce downtime, improves troubleshooting, and supports safer delivery.
- Technical depth level: Medium

---

## Slide 10 - Teamwork and Project Management

- Slide number: 10
- Slide title: Teamwork and Project Management
- Main message of the slide: The project worked best when infrastructure, automation, and application changes followed a shared delivery model.
- Exact text to place on the slide:

```text
Teamwork and Project Management

What worked well
Shared branch flow and environment standards
Automation reduced repetitive coordination work
Clear separation between platform setup and app deployment

What could improve
Earlier alignment on hardening standards and final acceptance criteria
```

- Key bullet points to include:
  - `dev` branch supports integration and lower-risk testing
  - `main` branch is treated as the production release path
  - Shared inventories, naming conventions, and workflows improved consistency
  - Platform provisioning and application deployment were separated into dedicated pipelines
  - Improvement area: define security and quality gates earlier in the project
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Simple branch-flow diagram or team workflow timeline
- Recommended visual layout:
  - Two-column layout
  - Left: what worked well
  - Right: what could improve
- Speaker notes:
  - Present this as the operating model visible in the implementation: branch discipline, environment separation, and workflow separation.
  - If the presenting team wants to personalize this slide later, they can add actual meeting cadence or role ownership, but the current version is already aligned to the repo evidence.
  - Keep the tone reflective, not defensive.
- Business value connection:
  - Better coordination lowers delivery friction and reduces late-stage production surprises.
- Technical depth level: Low

---

## Slide 11 - Major Obstacle: Biggest Technical and Operational Mistake

- Slide number: 11
- Slide title: Major Obstacle: Biggest Technical and Operational Mistake
- Main message of the slide: The biggest obstacle was realizing that a working deployment is not the same as a mature production platform.
- Exact text to place on the slide:

```text
Major Obstacle

Working deployment did not automatically mean production maturity

What we discovered
Security, testing, and operations need the same level of automation as infrastructure
```

- Key bullet points to include:
  - It was possible to reach a successful deployment before all hardening steps were complete
  - Some production-style gaps remained visible in the implementation
  - The platform foundation is strong, but maturity depends on tighter controls
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Maturity staircase or iceberg graphic labeled `works`, `secure`, `observable`, `maintainable`
- Recommended visual layout:
  - Large central graphic with three short lesson callouts around it
- Speaker notes:
  - This is the credibility slide.
  - Say clearly that the project succeeded technically, but also revealed that production readiness is a broader discipline than deployment alone.
  - This is where leadership hears honesty, and engineers hear that the team understands operational tradeoffs.
- Business value connection:
  - Honest recognition of gaps reduces future risk and increases stakeholder trust in the team.
- Technical depth level: High

---

## Slide 12 - Major Obstacle: What We Learned and What We Would Do Differently

- Slide number: 12
- Slide title: Major Obstacle: What We Learned and What We Would Do Differently
- Main message of the slide: The biggest lesson was to treat testing, secrets, and security hardening as first-class delivery requirements from day one.
- Exact text to place on the slide:

```text
What We Would Do Differently

Restrict backend CORS to approved domains only
Run backend tests automatically in CI
Reduce secret material written to disk on hosts
Add blue-green deployment and automated rollback
Harden Key Vault access and extend alerting
```

- Key bullet points to include:
  - Backend CORS is currently permissive and should be restricted
  - Backend GitHub Actions currently builds and scans but does not enforce tests in the workflow
  - Key Vault currently has network ACLs but still has public network access enabled
  - Internal app traffic is private inside Azure, but not end-to-end TLS between gateway and app VMs
  - Future rollout patterns should include rolling or blue-green deployment
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Roadmap timeline from `current state` to `next maturity level`
- Recommended visual layout:
  - Left: current gaps
  - Right: future-state actions
- Speaker notes:
  - Keep this slide practical and forward-looking.
  - Explain that the project created a solid foundation, and now the next step is to harden and operationalize it further.
  - This is a good place to say what changed in the team's thinking after working through real deployment details.
- Business value connection:
  - Shows a concrete path from good delivery automation to stronger resilience and governance.
- Technical depth level: High

---

## Slide 13 - Conclusion and Insights: Did the Project Meet the Objectives?

- Slide number: 13
- Slide title: Conclusion and Insights: Did the Project Meet the Objectives?
- Main message of the slide: The project met the core learning goals and delivered real platform value, while still identifying important next steps.
- Exact text to place on the slide:

```text
Did We Meet the Objectives?

Infrastructure as Code: Yes
Configuration automation: Yes
Environment separation: Yes
HTTPS and secure public access: Yes
Monitoring foundation: Yes
Operational hardening: Partially complete
```

- Key bullet points to include:
  - Terraform delivered repeatable shared, dev, and prod infrastructure
  - Ansible reduced manual host setup and deployment work
  - GitHub Actions automated release workflows
  - Domain and certificate integration created a professional public entry point
  - Monitoring and alerting improved platform maintainability
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Objective scorecard or traffic-light matrix
- Recommended visual layout:
  - Large scorecard in the center
  - Short summary statement at the bottom
- Speaker notes:
  - Give a direct answer: yes, the main objectives were met.
  - Add the nuance that "met" does not mean "finished forever"; it means the core foundation is in place and credible.
  - This is where you connect technical progress to business confidence.
- Business value connection:
  - Reinforces that the project created a platform that is faster to change, easier to repeat, and safer to operate than a manual approach.
- Technical depth level: Medium

---

## Slide 14 - Conclusion and Insights: Final Takeaways and Next Steps

- Slide number: 14
- Slide title: Conclusion and Insights: Final Takeaways and Next Steps
- Main message of the slide: The most important outcome is a shift from manual operations to a more disciplined delivery platform with a clear path to higher maturity.
- Exact text to place on the slide:

```text
Final Takeaways

The hardest part was not building the app
The hardest part was building a safe and repeatable delivery system

Business result:
More speed, more consistency, less manual risk

Next step:
Evolve from automated deployment to mature platform operations
```

- Key bullet points to include:
  - Add safer deployment patterns and automated rollback
  - Expand operational documentation and runbooks
  - Improve cost visibility and platform monitoring depth
  - Continue hardening secrets handling and access policies
- Picture idea, diagram idea, or screenshot idea for that slide:
  - Transformation graphic: `manual operations -> automated platform -> mature operating model`
- Recommended visual layout:
  - Large closing statement on the left
  - Roadmap or transformation visual on the right
- Speaker notes:
  - End with a CEO-friendly conclusion: this project improves how software can be delivered and operated, not just where one app happens to run.
  - Keep the close short and strong.
  - Invite the audience to see the project as a business-enabling platform foundation.
- Business value connection:
  - Summarizes the transformation in terms leadership can use: speed, consistency, reliability, and controlled growth.
- Technical depth level: Medium

---

## Supporting Notes for Slide Creation

- Recommended screenshots to capture before building the final slide deck:
  - GitHub Actions workflow runs for:
    - `platform.yml`
    - `frontend-ci-cd.yml`
    - `backend-ci-cd.yml`
  - Azure portal overview for:
    - Application Gateway
    - Resource groups for shared, dev, and prod
    - Key Vault
    - Azure SQL private endpoint
    - Azure Monitor alerts or dashboards
  - Browser screenshot showing HTTPS lock and public domain
  - Terraform plan or apply console output
  - Ansible playbook run output for frontend or backend deployment

- Recommended visuals that should be custom-designed rather than taken as raw screenshots:
  - Before vs after diagram
  - Dev vs prod environment separation diagram
  - Traffic flow and HTTPS routing diagram
  - Secret flow diagram
  - Delivery pipeline diagram
  - Maturity roadmap or lessons-learned graphic

- Presenter customization placeholders:
  - Replace presenter names on Slide 1
  - If available, add real team role ownership to Slide 10
  - If Azure portal confirms the exact certificate type, update Slide 7 speaker notes accordingly

