# Engineering Best Practices Audit — datadog_notifier

| | |
|---|---|
| **Audit date** | 2026-09-08 |
| **Auditor** | Claude — gauge-repo skill |
| **Rubric version** | `item-credit-v1` — 2026-09-04 (`references/best-practices.md`) |

No prior audit report found at this path — this is the first `gauge-repo` audit of this repository.

## Repo profile

`datadog_notifier` is a **published Ruby gem** — the only library in this batch of DATA repos, and the only repository here whose artifact is consumed by other teams rather than deployed. It wraps Datadog's tracer to send custom errors to the Datadog Error Tracking dashboard, tagged `@custom_dd_notifier:true` so they can be filtered, with a single public entry point: `DatadogNotifier.notify(exception, payload_json)`.

**Size:** 45 lines of Ruby across three files — `lib/datadog_notifier.rb` (36), `lib/datadog_notifier_exception.rb` (4), and `lib/datadog_notifier/version.rb` (5, currently `1.0.4`).

**Distribution model:** RubyGems. `.github/workflows/publish.yml` triggers on `v*` tags, runs `gem build datadog_notifier.gemspec`, and pushes with `RUBYGEMS_API_KEY`. Consumers add `gem 'datadog_notifier'` to their Gemfile — the README documents that version `<= 1.0.4` is required for Ruby below 3.4.

**Dependency handling is conditional at build time.** The gemspec branches on `RUBY_VERSION`: `datadog >= 2.0.0` when the building interpreter is Ruby 3.4 or newer, `ddtrace >= 1.13.0` otherwise. `required_ruby_version` is `>= 2.7.0`. This is the most consequential technical fact in the repository — see item 48.

**Persistence, UI, deployment:** none. This is a library; it runs inside its consumers' processes.

**Team signals:** four contributors — Amol Udage (28 commits), mukteshd (6), Shaunak Sontakke (2), plus the runner bot. Last commit is `Onboard datadog-notifier to Backstage` (2026-07-29) from the automation bot.

**AWS footprint:** none. The gem talks to Datadog through the host application's tracer; there is no deployment, IaC, or AWS usage. Item 49's core manifest applies; the `aws[]` sub-check has nothing to describe.

**GitHub owner:** verified `patterninc/datadog_notifier` via `gh repo view --json nameWithOwner` (default branch `main`). Pattern's inherited Wiz and Toolsmith controls apply.

## Scorecard

| Metric | Value |
|--------|-------|
| **Critical gates** | **RED** |
| **Adjusted compliance** | **19.1%** |

Five of the ten applicable critical gates are not fully Met, so the safety floor is **RED**. Adjusted compliance is calculated independently:

`(6 Met + 0.5 × 1 Partial) / (49 total - 15 justified N/A) = 6.5 / 34 = 19.1%`

### Critical gate detail

| # | Gate | Status |
|---|------|--------|
| 2 | AGENTS.md | **Gap** |
| 6 | README setup & run instructions | Partial |
| 15 | Branch protection | **Met** |
| 16 | Required CI checks before merge | **Gap** |
| 19 | Secret scanning | **Met** |
| 20 | SAST gate | **Met** |
| 23 | Unit tests | **Gap** |
| 24 | Integration tests | **Gap** |
| 40 | Scoped secrets per environment | **Met** |
| 48 | Reproducible builds (lockfiles) | **Gap** |

For a published library the testing gates carry more weight than usual: this gem is installed into other Pattern applications' production processes, and a defect ships to all of them at once. There is no test of any kind, and no CI job that would run one — `rspec` is declared as a development dependency in the gemspec and there is no `spec/` directory.

### Status totals

| Status | Items |
|--------|------:|
| Met | 6 |
| Partial | 1 |
| Gap | 27 |
| N/A | 15 |
| **Total** | **49** |

### Per-category breakdown

| Category | Met | Partial | Gap | N/A |
|----------|----:|--------:|----:|----:|
| Documentation & Context | 0 | 1 | 5 | 3 |
| Guardrails & Enforcement | 3 | 0 | 8 | 2 |
| Testing & Feedback Loops | 0 | 0 | 8 | 5 |
| Environment & Tooling | 3 | 0 | 5 | 5 |
| Agent dispatch | 0 | 0 | 1 | 0 |
| **Total** | **6** | **1** | **27** | **15** |

## Documentation & Context

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 1 | Skills / reusable prompt workflows | **Gap** | No `.claude/` or `.cursor/` directory | The one repeatable task worth capturing is the release: bump `version.rb`, tag `v*`, let `publish.yml` push. Today that sequence is knowable only by reading the workflow. |
| 2 | AGENTS.md | **Gap** | No `AGENTS.md` or `CLAUDE.md` | **Critical gate.** The facts an agent needs are non-obvious and unwritten: the release is tag-triggered, the version lives in `lib/datadog_notifier/version.rb`, the runtime dependency is chosen by the *builder's* Ruby version, and the gem must not `require` its dependency at gemspec load time (a constraint the gemspec's own comment explains). |
| 3 | Architecture decision records | **Gap** | No decision records. The `datadog` versus `ddtrace` split — the single most consequential design choice here — is captured only as an `if` statement in the gemspec and one README line | Record why the conditional exists and what the migration path off it is. A future maintainer will otherwise read it as an accident. |
| 4 | Runbooks | **Gap** | No release or rollback documentation. Nothing describes how to yank a bad version from RubyGems, or what to tell consumers when one ships | For a published library, "how do we un-ship" is the runbook that matters, and it does not exist. |
| 5 | API contract docs (OpenAPI / protobuf) | **Not applicable** | The gem publishes no wire protocol. Its interface is a Ruby method signature, documented in the README and scored under item 6 | Profile-backed: in-process library with no network contract. |
| 6 | README with setup & run instructions | **Partial** | Genuinely good on the consumer side: installation via Gemfile or `gem install`, the `DatadogNotifier.notify(exception, payload_json)` call with both arguments explained, the prerequisite that Datadog's tracer is already integrated, the Ruby-version constraint (`use version <= 1.0.4 for ruby < 3.4`), and a link to the Error Tracking dashboard plus the `@custom_dd_notifier:true` filter. What is entirely missing is the contributor side: no local setup, no test command, no release procedure, no contribution notes | **Critical gate.** The README serves users well and maintainers not at all — which is why the release process in item 1 is undocumented. |
| 7 | Changelog with migration notes | **Gap** | No `CHANGELOG.md`, for a **versioned, published gem currently at 1.0.4** whose README already documents a version-dependent breaking constraint | This is the repository in the batch with the strongest case for a changelog — "changelog with migration notes" describes exactly the `ddtrace`→`datadog` situation the README explains in prose. |
| 8 | On-call playbooks | **Not applicable** | A library with no deployed runtime of its own; failures surface inside consumers' applications and are handled by those teams' rotations | Profile-backed: no owned production surface. |
| 9 | CODEOWNERS | **Not applicable** | Four contributors, one dominant maintainer, 45 lines of code; the repository's own branch-protection ruleset already requires review | Profile-backed: path-based routing does not fit a three-file library. |

## Guardrails & Enforcement

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 10 | Linters | **Gap** | No `.rubocop.yml` and no lint step, despite `frozen_string_literal` comments suggesting someone had a style standard in mind | RuboCop on 45 lines runs instantly and would be the first automated check this repo has ever had. |
| 11 | Formatters | **Gap** | No formatter configuration and no `.editorconfig` | Free alongside item 10. |
| 12 | Type checking | **Gap** | No RBS signatures or Sorbet sigils | For a published gem, RBS signatures are also consumer-facing documentation — modest effort, real value at this size. |
| 13 | Pre-commit hooks | **Gap** | No hook configuration | Worth adding once item 10 exists. |
| 14 | Commit message conventions | **Gap** | Ad hoc history with no convention or enforcement | Low priority on its own, but it is what makes the changelog in item 7 generable. |
| 15 | Branch protection rules | **Met** | Two active rulesets apply: the organization's `require-pr-review` (source `patterninc`) and a repository-specific `Datadog Notifier Branch Protection`. Both are enforcement-active on the default branch | Among the few repos in this batch with protection of its own rather than only the inherited org rule. |
| 16 | Required CI checks before merge | **Gap** | `publish.yml` is the only workflow and it triggers on `v*` tags. **Nothing runs on `pull_request` or on push** — no build, no lint, no test — and there are no required status checks. The first execution of any change is the release that publishes it to RubyGems | **Critical gate.** A workflow that runs `gem build` and a test suite on pull requests would mean a broken gemspec is caught before it becomes a published version rather than after. |
| 17 | Dependency allow-lists / deny-lists | **Gap** | No policy governs the runtime dependency, which is chosen conditionally at build time between `datadog` and `ddtrace` | Low priority as policy, but see item 48 — the conditional itself is the problem. |
| 18 | License compliance scanning | **Gap** | No scanning of dependency licenses. The gem itself correctly declares `spec.license = 'MIT'` and ships `LICENSE.txt` | Low priority. |
| 19 | Secret scanning | **Met** | Inherited Pattern Wiz org-wide secret scanning (owner verified as `patterninc`). The one credential in play, `RUBYGEMS_API_KEY`, is referenced from GitHub Actions secrets and never inlined | Met — inherited Pattern Wiz policy. |
| 20 | SAST / static analysis gates | **Met** | Inherited Pattern Wiz org-wide SAST and blocking policy (owner verified as `patterninc`) | Met — inherited Pattern Wiz policy, and currently the only static analysis of any kind touching this gem. |
| 21 | Max complexity limits | **Gap** | No complexity rule, following from having no linter (item 10) | Free once item 10 lands; unlikely to bind at 45 lines. |
| 22 | Import boundary enforcement | **Not applicable** | Three files in one flat `lib/` directory with no layers to protect | Profile-backed. |

## Testing & Feedback Loops

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 23 | Unit tests | **Gap** | **No tests at all** — no `spec/` or `test/` directory — although the gemspec declares `spec.add_development_dependency 'rspec'` and explicitly excludes `^(test|spec|features)/` from the packaged files, so the intent was clearly there at some point | **Critical gate**, and the highest-value fix here. `DatadogNotifier.notify` has exactly the shape unit tests exist for: an exception in, a tagged Datadog span out, plus an optional payload. Three specs would cover the whole public surface. |
| 24 | Integration tests | **Gap** | Nothing verifies the gem against a real Datadog tracer, or that the `datadog`/`ddtrace` branch selected at build time actually works with the API the code calls | **Critical gate.** This is where the conditional dependency in item 48 becomes dangerous: the two libraries are not API-identical, and nothing checks either path. |
| 25 | Snapshot / golden-file tests | **Gap** | No golden files. The span/tag payload the gem constructs is the natural candidate | Cheap regression guard for a published interface. |
| 26 | Contract tests (Pact) | **Not applicable** | No service contract: this is an in-process library, and its interface is a Ruby method covered by items 6 and 23 rather than a provider/consumer wire contract | Profile-backed. |
| 27 | End-to-end tests (Playwright) | **Not applicable** | No browser UI — a library with no user interface | Profile-backed. |
| 28 | Visual regression tests | **Not applicable** | No visual surface | Profile-backed. |
| 29 | Test coverage thresholds | **Gap** | No coverage measurement | Add SimpleCov with the first specs; at 45 lines a high floor is genuinely achievable. |
| 30 | Mutation testing | **Gap** | No mutation tooling | Low priority until base tests exist. |
| 31 | Load / performance benchmarks | **Not applicable** | The gem does one thing per invocation — forward an exception to the host's tracer — with no throughput characteristic of its own to measure; performance belongs to the Datadog client it delegates to | Profile-backed. |
| 32 | Flaky test quarantine | **Gap** | No quarantine mechanism | Not meaningful until a suite exists; a Gap rather than N/A because "not yet" is not a rationale for declining. |
| 33 | Structured CI output | **Gap** | No test job, therefore no reporter or artifact | Comes with item 16. |
| 34 | Deterministic test fixtures | **Gap** | No fixtures, following from having no tests | A canned exception object and payload hash is all item 23 needs. |
| 35 | Smoke tests for deploys | **Gap** | `publish.yml` ends at `gem push`. Nothing afterwards installs the published gem and verifies it loads — so a gem that builds but cannot be required is discovered by a consumer, not by the pipeline | Add a post-publish step that installs the just-pushed version in a clean container and calls `require 'datadog_notifier'`. Cheap, and it directly guards the conditional in item 48. |

## Environment & Tooling

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 36 | Devcontainer config | **Gap** | No `.devcontainer/`, no `.ruby-version`, and no `Gemfile` for development. Given that the build output depends on the interpreter version (item 48), an unpinned development environment is a real hazard rather than a convenience gap | Pin a Ruby version at minimum. |
| 37 | One-command setup (make dev) | **Gap** | No `bin/setup`, no Rakefile, no documented command | `bundle install && rake spec` is the conventional shape; none of the three pieces exist. |
| 38 | Seed scripts for local databases | **Not applicable** | No database | Profile-backed. |
| 39 | MCP servers for external tools | **Met** | Toolsmith-managed MCP access (owner verified as `patterninc`); no repo-local `.mcp.json` required | Met — Toolsmith-managed MCP access. |
| 40 | Scoped secrets per environment | **Met** | One credential exists — `RUBYGEMS_API_KEY` — sourced from GitHub Actions secrets in `publish.yml` and never inlined. There is one publication target, so environment separation is satisfied by there being a single correctly-scoped environment | **Critical gate: Met**, on a genuinely small surface. |
| 41 | Preview environments per PR | **Not applicable** | Nothing is deployed; the artifact is a published gem | Profile-backed. |
| 42 | Hot-reload / watch mode | **Not applicable** | A library with no runtime process of its own to reload; the development loop is running specs | Profile-backed. Note the specs do not exist (item 23). |
| 43 | Structured logging (JSON) | **Not applicable** | The gem emits no logs of its own — its entire purpose is to forward errors into the host application's Datadog tracer, which is itself the structured output path | Profile-backed. |
| 44 | Observable traces and metrics | **Not applicable** | The library has no runtime to observe; it produces telemetry inside its consumers rather than emitting its own | Profile-backed. |
| 45 | Feature flags with local overrides | **Not applicable** | No deployed runtime and no toggleable behaviour; the only conditional is the build-time dependency choice in item 48 | Profile-backed. |
| 46 | Database migration tooling | **Not applicable** | No database | Profile-backed. |
| 47 | Dependency update automation | **Met** | Org-wide Wiz coverage for verified Pattern repos (owner verified as `patterninc`) | Met — inherited Pattern Wiz policy. Do not add Dependabot. |
| 48 | Reproducible builds (lockfiles) | **Gap** | The gemspec selects its runtime dependency from the **building machine's** interpreter: `if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.4')` then `datadog >= 2.0.0`, else `ddtrace >= 1.13.0`. `publish.yml` has **no `setup-ruby` step at all**, so the dependency baked into a published gem is decided by whatever Ruby the GitHub runner image happens to ship that week. Both dependencies are floor-pinned (`>=`) rather than bounded, and `spec.files` is computed by shelling out to `git ls-files` at build time | **Critical gate**, and the most serious technical finding in this report. Two builds of the same commit can produce gems with different dependencies. Pin the Ruby version in `publish.yml`, and replace the conditional with either explicit per-Ruby gem variants or a single dependency with an upper bound. |

## Documentation & Context (agent dispatch)

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 49 | Agent-dispatch manifest (`.agents/pattern-agents.json`) | **Gap** | No `.agents/` directory. `backstage.yaml` is present, added by the onboarding bot | Add `.agents/pattern-agents.json` with the core fields. The `aws[]` array does not apply — the gem has no AWS footprint. |

## Prioritized recommendations

Ordered by the scoring reference: incomplete critical gates first (Gap before Partial), then remaining Gaps before remaining Partials, then blast radius, then effort. Effort and current status are shown on every line.

**Critical gates:**

1. **[S] #48 Gap — reproducible builds.** Add a `setup-ruby` step pinning an explicit version in `publish.yml`, and replace the `RUBY_VERSION` conditional in the gemspec with a deterministic dependency declaration. **Do this first** — today the published artifact depends on the runner image, and that is invisible until a consumer breaks.
2. **[S] #16 Gap — required CI checks.** Run `gem build` and the test suite on pull requests and register them as required checks, so a change is executed before it is published rather than by being published.
3. **[S] #23 Gap — unit tests.** Three specs cover the whole public surface: an exception with no payload, one with a payload, and the `@custom_dd_notifier` tag.
4. **[M] #24 Gap — integration tests.** Verify against a real tracer on both the `datadog` and `ddtrace` paths — the two libraries are not API-identical and neither path is currently checked.
5. **[S] #6 Partial — README.** Add the contributor half: local setup, how to run specs, and the tag-based release procedure.
6. **[S] #2 Gap — AGENTS.md.** The release mechanics, the version file location, and the gemspec's load-order constraint.

**Remaining Gaps:**

7. **[S] #35 Gap — post-publish smoke test.** Install the just-published version in a clean container and `require` it.
8. **[S] #7 Gap — changelog.** Start at 1.0.4 and record the `ddtrace`→`datadog` transition the README already describes in prose.
9. **[M] #4 Gap — runbooks.** How to yank a bad release and what to tell consumers.
10. **[S] #36 Gap — pin a Ruby version** for development, matching recommendation 1.
11. **[S] #37 Gap — one-command setup.** `bundle install && rake spec`, once a Rakefile and specs exist.
12. **[S] #10 Gap — linters** and **[S] #11 Gap — formatters.** RuboCop covers both on 45 lines.
13. **[S] #49 Gap — agent-dispatch manifest.** Core fields; no `aws[]`.
14. **[S] #25 Gap — golden-file tests**, **[S] #29 Gap — coverage thresholds**, **[S] #33 Gap — structured CI output**, **[S] #34 Gap — deterministic fixtures.** All land alongside recommendation 3.
15. **[M] #3 Gap — ADRs.** Record why the conditional dependency exists and how it ends.
16. **[S] #12 Gap — type checking.** RBS signatures double as consumer documentation.
17. **[S] #13 Gap — pre-commit hooks**, **[S] #14 Gap — commit conventions**, **[S] #17 Gap — dependency policy**, **[S] #18 Gap — license scanning**, **[S] #21 Gap — complexity limits**, **[M] #30 Gap — mutation testing**, **[S] #32 Gap — flaky quarantine**, **[S] #1 Gap — skills.** Lower priority; itemized with rationale in the tables above.

One finding maps to no checklist item but is worth raising:

- **`publish.yml` uses `actions/checkout@v2` and pushes to RubyGems with no version pinning anywhere in the job** — no `setup-ruby`, no pinned `gem` version, and an action three majors behind. This is the job that holds `RUBYGEMS_API_KEY` and publishes a package into other Pattern applications' dependency trees; it deserves the most careful pinning in the repository and currently has the least.

## Declined practices

| # | Practice | Rationale |
|---|----------|-----------|
| 5 | API contract docs (OpenAPI / protobuf) | In-process library with no wire protocol. Its interface is a Ruby method signature, documented under item 6. |
| 8 | On-call playbooks | No deployed runtime of its own; failures surface inside consumer applications and are handled by those teams. |
| 9 | CODEOWNERS | Four contributors and 45 lines of code; the repository's own branch-protection ruleset already requires review. |
| 22 | Import boundary enforcement | Three files in one flat `lib/` directory with no layers. |
| 26 | Contract tests (Pact) | No provider/consumer wire contract — an in-process library whose interface is covered by items 6 and 23. |
| 27 | End-to-end tests (Playwright) | No browser UI. |
| 28 | Visual regression tests | No visual surface. |
| 31 | Load / performance benchmarks | One forwarding call per invocation with no throughput characteristic of its own; performance belongs to the Datadog client it delegates to. |
| 38 | Seed scripts for local databases | No database. |
| 41 | Preview environments per PR | Nothing is deployed; the artifact is a published gem. |
| 42 | Hot-reload / watch mode | No runtime process of its own; the development loop is running specs. |
| 43 | Structured logging (JSON) | The gem emits no logs of its own — it forwards errors into the host application's Datadog tracer, which is the structured output path. |
| 44 | Observable traces and metrics | No runtime to observe; it produces telemetry inside its consumers rather than emitting its own. |
| 45 | Feature flags with local overrides | No deployed runtime and no toggleable behaviour. |
| 46 | Database migration tooling | No database. |

## Beyond the checklist

- **The README is written for its actual audience.** Installation, the exact call signature, the prerequisite that Datadog's tracer is already integrated, the Ruby-version constraint, and — best of all — the `@custom_dd_notifier:true` filter string with a link to the dashboard where you would use it. That last detail is the difference between a library you can adopt and one you have to reverse-engineer.
- **The gemspec's load-order comment is real institutional knowledge.** "Don't require datadog_notifier here - it has dependencies that aren't installed yet during bundle install" documents a genuine and easily-reintroduced packaging bug. It belongs in an ADR (recommendation 15) rather than only in a comment.
- **The repository has branch protection of its own**, not merely the inherited organization ruleset — one of the few in this batch, and a deliberate act by someone.
- **The version-compatibility problem was noticed and communicated.** The README's "use version <= 1.0.4 for ruby <3.4" line means a maintainer understood the `ddtrace`/`datadog` split and told consumers about it. The gap is that this understanding lives in prose while the mechanism enforcing it (item 48) is non-deterministic.
