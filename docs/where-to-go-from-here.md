# Where do you go from here?

You forked this repo, connected Terraform to AWS, and (if you followed training) stood up WordPress on Lightsail. **This document is a roadmap** — not a checklist to run today. Each section becomes its own **speckit spec** on a feature branch, with plan, tasks, reviewed `terraform plan`, and a PR merge — the same pattern you used in §3 and §4.

**AI agents:** treat each section below as a future spec. Do not implement without `spec.md` / `plan.md` / `tasks.md` and operator approval.

---

## What you have now

| Piece | Purpose |
|-------|---------|
| Your org’s GitHub repo | Version history, accountability, backup of infrastructure code |
| Terraform remote state (S3) | Durable record of what AWS resources Terraform manages |
| Lightsail WordPress (spec 003) | Website on a **static IP** — usually `http://<ip>` until DNS and HTTPS |
| `.secrets/tu.keys` | IAM access for Terraform — never in git |
| Constitution + `progress.ai` | Safety rules and decision log |

Your site may still be on a raw IP address. Donors and staff expect **`https://www.yournonprofit.org`** — that requires DNS (Route53 or your registrar), often HTTPS, and usually better email (SES). Moving an **existing** WordPress site from GoDaddy, Bluehost, or another host is a separate, careful project.

---

## How every next project should run

Same workflow every time:

1. Load `start.ai` and run `scripts/check-session-prereqs.sh`
2. Tell your AI something like: *“Using speckit, GitHub, and our constitution, create spec 00X for [goal], branch, plan, tasks, guide me through plan, then help me merge.”*
3. Work on a **feature branch** — never commit infra changes straight to `main`
4. **`terraform plan`** — read it with your AI before any apply
5. **`terraform apply`** — only when **you** explicitly approve
6. Update **`progress.ai`** and merge via PR

Number specs sequentially: **004**, **005**, **006**, …

---

## Recommended order

| Order | Spec (suggested) | Why this order |
|-------|------------------|----------------|
| 1 | **004 — Route53 DNS** | Gives you a real hostname pointing at your Lightsail static IP; foundation for HTTPS and SES domain verification |
| 2 | **005 — Amazon SES** | Reliable outbound email (WordPress notifications, forms, staff mail); works best once you control DNS for DKIM |
| 3 | **006 — WordPress migration** | Move content from old host to Lightsail; often done **before** DNS cutover on a temp URL, then switch DNS |

You can reorder if your situation demands it (e.g. migration before cutover is common; DNS spec might only add the zone while migration uses IP). Discuss tradeoffs in the spec’s `plan.md`.

---

## Spec 004 — Route53 (custom domain)

### What it solves

Visitors reach your site at **`www.yournonprofit.org`** instead of an IP. Route53 hosts DNS for your domain (or you can keep DNS at your registrar and only add records — the spec should choose one approach).

### Typical scope

- Route53 **hosted zone** for your domain (Terraform: `aws_route53_zone`)
- **A record** (or ALIAS) pointing `www` (and optionally apex `@`) to the Lightsail **static IP** from spec 003 output `wordpress.static_ip`
- Document registrar steps if the domain is registered elsewhere (transfer registrar DNS to Route53 nameservers, or add records at registrar)
- Optional: Lightsail **load balancer + certificate** for HTTPS on the custom domain (more moving parts than HTTP-on-IP)

### Out of scope for a first DNS spec

- Moving domain registration from GoDaddy (separate decision)
- Email hosting (MX records) — coordinate with SES spec or existing Google Workspace

### Prompt to give your AI

```
Using speckit, GitHub, and our constitution, create spec 004 for Route53 DNS so our
nonprofit domain points to our Lightsail WordPress static IP. Branch, plan, and tasks.
Walk me through terraform plan before any apply. Help me merge to main and update progress.ai.
```

### Notes

- You need the **domain name** and access to your **registrar** (where you bought the domain).
- After apply, DNS propagation can take minutes to 48 hours.
- Record the hosted zone ID and nameservers in `progress.ai`.

---

## Spec 005 — Amazon SES (email)

### What it solves

WordPress and your org need to **send email** (password resets, form notifications, receipts). SES is AWS’s transactional email service — inexpensive and reliable when configured correctly. Spam reputation matters for nonprofits too.

### Typical scope

- **SES domain identity** (verify `yournonprofit.org` via DNS TXT/CNAME — easier after Route53 spec)
- **DKIM** and **MAIL FROM** records in Route53
- Move account out of SES **sandbox** (production access request — AWS reviews use case; explain nonprofit transactional mail)
- IAM policy for WordPress/Lightsail to send via SMTP or API (credentials in `.secrets/`, not git)
- Optional: configure WordPress SMTP plugin to use SES

### Out of scope for v1

- Marketing newsletters at scale (consider dedicated tools)
- Full Google Workspace / Microsoft 365 replacement
- Inbound email routing

### Prompt to give your AI

```
Using speckit, GitHub, and our constitution, create spec 005 for Amazon SES so our
WordPress site can send mail from our domain. Include DNS verification and sandbox exit.
Branch, plan, tasks; no apply without my approval after plan review. Merge and debrief when done.
```

### Notes

- **Sandbox:** until lifted, you can only send to verified addresses — plan for testing.
- **Bounce/complaint handling:** document in plan for production.
- Never commit SMTP passwords; use `.secrets/` and document format in `.secrets/*.example` if needed.

---

## Spec 006 — Migrate existing WordPress to Lightsail

### What it solves

You already have WordPress elsewhere (GoDaddy, Bluehost, WP Engine, another host). You want **the same content** (posts, pages, media, users) on the Lightsail instance Terraform manages — without a long outage or lost data.

### Typical scope (plan should detail tools)

1. **Inventory** — URL of old site, WordPress version, plugins, approximate size, who has admin access
2. **Backup old site** — full backup before touching anything (plugin export, hosting backup, or `wp db export` + `wp-content` archive)
3. **Prepare Lightsail target** — confirm spec 003 site is healthy; create staging approach if needed
4. **Migrate content** — common paths:
   - **All-in-One WP Migration** or **Duplicator** plugin (operator-friendly)
   - **Manual:** database dump + `wp-content` copy + search-replace URLs
   - **WP-CLI** on both ends if SSH is available
5. **Search-replace URLs** — old domain → new domain or IP (careful with serialized PHP data)
6. **Test** on IP or temporary hostname before DNS cutover
7. **Cutover** — lower TTL beforehand; switch DNS (spec 004); verify HTTPS and forms
8. **Decommission old host** — only after bake-in period; document in `progress.ai`

### Out of scope for v1

- Zero-downtime enterprise migration
- WooCommerce with complex payment flows (needs extra testing)
- Rebuilding the site redesign during migration (scope creep)

### Prompt to give your AI

```
Using speckit, GitHub, and our constitution, create spec 006 to migrate our existing
WordPress site from [OLD HOST] to our Lightsail WordPress. Branch, plan, and tasks.
Emphasize backup first and testing before DNS cutover. No destructive steps without my approval.
```

### Notes

- **Terraform** may not manage migration itself — much of this is operational runbook in `tasks.md`. That is fine; the spec still governs the work (Constitution III).
- **Downtime:** plan a maintenance window or staged cutover.
- **Media files:** large uploads can dominate migration time.
- Keep old host running until you are confident in the new site.

---

## Other paths (future specs)

| Idea | Spec topic |
|------|------------|
| HTTPS only, HSTS | Lightsail certificate or ACM + LB |
| Backups | Lightsail snapshots, S3 backups, backup plugin |
| Staging environment | Second Lightsail instance or smaller bundle |
| CI/CD for Terraform | GitHub Actions plan on PR |
| Import legacy AWS resources | Brownfield `terraform import` |
| WooCommerce / donations | Plugin + payment compliance review |

---

## Constitution reminders (still apply)

- **Terraform-first** for AWS infrastructure — console clicks for migration plugins are OK; codify any lasting AWS changes in Terraform afterward.
- **No apply** without reviewed plan and explicit approval.
- **Branch discipline** — one spec per branch/PR when possible.
- **Secrets** — SES SMTP keys, migration credentials stay in `.secrets/`, not git or chat.
- **Traceability** — every spec ends with `progress.ai` entries your board could audit.

---

## Quick reference

| Doc | When |
|-----|------|
| `start.ai` | Every session |
| `AGENTS.md` | AI entrypoint |
| `setup/speckitSecondTrainingWordPress.md` | If spec 003 not done yet |
| `.specify/memory/constitution.md` | Before any apply |
| `specs/003-wordpress-lightsail/` | WordPress reference |

When in doubt, ask your AI: *“Read `docs/where-to-go-from-here.md` and help me draft spec 004 for our domain.”*
