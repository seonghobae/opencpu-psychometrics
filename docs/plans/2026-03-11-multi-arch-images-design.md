# Multi-Arch Images Design

## Context

- The repository currently publishes a single-platform image from
  `.github/workflows/docker-publish.yml`.
- Buildx is already configured, but the workflow does not declare
  `platforms` and does not install QEMU.
- Signing and SBOM steps already consume the digest from
  `docker/build-push-action`, which can remain the manifest-list digest
  in a multi-arch build.
- The product goal is a GHCR image that is easy to consume from CI and
  deployments; adding `linux/amd64` and `linux/arm64` aligns with that
  goal without changing the runtime contract.

## Constraints

- Keep the Dockerfile behavior intact unless architecture-specific
  breakage is observed.
- Preserve current tag, signing, and SBOM behavior.
- Keep the workflow pinned to explicit action SHAs.
- Add tests before workflow changes.
- Update `ARCHITECTURE.md` because build behavior changes.

## Approaches

### Approach A: Single Buildx job with QEMU and multi-platform output

- Add `docker/setup-qemu-action`.
- Set `platforms: linux/amd64,linux/arm64` in the existing
  `docker/build-push-action` step.
- Keep one workflow job and reuse the manifest-list digest for signing
  and SBOM generation.

Trade-offs:

- Smallest diff and preserves the existing release flow.
- Slowest step becomes slower, but caching and current downstream logic
  stay simple.

### Approach B: Matrix builds per architecture plus manifest assembly

- Build amd64 and arm64 separately.
- Publish per-arch images, then assemble a manifest list.

Trade-offs:

- Better isolation and clearer per-arch failures.
- Considerably more workflow complexity and more moving parts for
  signing/SBOM generation.

### Approach C: Keep PR builds single-arch and publish multi-arch only on main/schedule

- Use multi-arch on push/schedule and single-arch on pull requests.

Trade-offs:

- Reduces PR cost.
- Leaves pull requests unable to validate the arm64 path, which weakens
  confidence in the main publish path.

## Recommendation

Choose Approach A.

It is the smallest safe change, matches the current workflow structure,
and preserves current signing and SBOM logic. The repository already
accepts long Docker builds, so the most important outcome is making both
target architectures part of the same verified pipeline rather than
adding a second publishing model.

## Design

- Add a workflow regression test in
  `tests/test_docker_publish_workflow.py` that asserts the Docker
  workflow sets up QEMU and declares both `linux/amd64` and
  `linux/arm64`.
- Update the Docker workflow to install QEMU before Buildx and to set the
  multi-platform list on the existing build step.
- Keep signing and SBOM logic on the existing digest output.
- Update `ARCHITECTURE.md` to record that the publish pipeline now emits
  a multi-architecture manifest list.

## Error Handling

- If arm64 package availability breaks later, the workflow should fail in
  the existing build step rather than silently publishing amd64 only.
- No fallback to single-arch publishing is added in this change; failure
  should remain explicit.

## Testing

- Add failing tests in `tests/test_docker_publish_workflow.py` for QEMU
  setup and the `platforms` declaration.
- Run `python3 -m unittest discover -s tests -v`.
- Run a YAML/workflow lint pass if available through the repo tooling.

## Decisions

- Safe default: validate both architectures in the same workflow rather
  than treating arm64 as optional.
- Safe default: workflow-only change first; no Dockerfile branching.
- Safe default: keep PR builds multi-arch so the arm64 path is exercised
  before merge.
