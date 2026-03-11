# Multi-Arch Images Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use
> superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build and publish `opencpu-psychometrics` images for both
`linux/amd64` and `linux/arm64` in the existing GitHub Actions
workflow.

**Architecture:** Keep the single Docker workflow job and extend it to
build a multi-platform manifest list with QEMU + Buildx. Add
regression tests that assert the workflow is configured for both target
architectures, then update build documentation to reflect the new
publish behavior.

**Tech Stack:** GitHub Actions workflow YAML, Docker Buildx, QEMU,
Python `unittest`

---

## Task 1: Add failing workflow tests

**Files:**

- Create: `tests/test_docker_publish_workflow.py`
- Test: `tests/test_docker_publish_workflow.py`

### Step 1: Write the failing test

```python
import pathlib
import unittest


WORKFLOW = (
    pathlib.Path(__file__).resolve().parents[1]
    / ".github/workflows/docker-publish.yml"
)


class DockerWorkflowMultiArchTest(unittest.TestCase):
    def setUp(self) -> None:
        self.content = WORKFLOW.read_text(encoding="utf-8")

    def test_workflow_sets_up_qemu_for_cross_arch_builds(self) -> None:
        self.assertIn("docker/setup-qemu-action", self.content)

    def test_workflow_builds_amd64_and_arm64(self) -> None:
        self.assertIn("platforms: linux/amd64,linux/arm64", self.content)
```

### Step 2: Run test to verify it fails

Run: `python3 -m unittest tests.test_docker_publish_workflow -v`
Expected: FAIL because QEMU and the multi-arch `platforms` line do
not exist yet.

### Step 3: Commit

Do not commit yet.

## Task 2: Update the workflow minimally

**Files:**

- Modify: `.github/workflows/docker-publish.yml`
- Test: `tests/test_docker_publish_workflow.py`

### Step 1: Write minimal implementation

Add a pinned `docker/setup-qemu-action` step before Buildx and add:

```yaml
platforms: linux/amd64,linux/arm64
```

to the `docker/build-push-action` step.

### Step 2: Run targeted tests to verify they pass

Run: `python3 -m unittest tests.test_docker_publish_workflow -v`
Expected: PASS

### Step 3: Run the full test suite

Run: `python3 -m unittest discover -s tests -v`
Expected: PASS

## Task 3: Update architecture docs

**Files:**

- Modify: `ARCHITECTURE.md`
- Modify: `AGENTS.md` (if verification guidance needs to mention
  workflow config tests)

### Step 1: Document the new behavior

Update `ARCHITECTURE.md` so the build pipeline section states that the
workflow now emits a multi-architecture manifest list for amd64 and
arm64.

### Step 2: Verify docs remain lint-clean

Run: `markdownlint-cli2 AGENTS.md ARCHITECTURE.md README.md`

Run: `markdownlint-cli2 docs/plans/2026-03-11-multi-arch-images-design.md docs/plans/2026-03-11-multi-arch-images.md`

Expected: PASS

## Task 4: Final verification and commit

**Files:**

- Modify: `.github/workflows/docker-publish.yml`
- Create: `tests/test_docker_publish_workflow.py`
- Modify: `ARCHITECTURE.md`
- Create: `docs/plans/2026-03-11-multi-arch-images-design.md`
- Create: `docs/plans/2026-03-11-multi-arch-images.md`

### Step 1: Run verification

Run:

```bash
python3 -m unittest discover -s tests -v
markdownlint-cli2 AGENTS.md ARCHITECTURE.md README.md
markdownlint-cli2 docs/plans/2026-03-11-multi-arch-images-design.md docs/plans/2026-03-11-multi-arch-images.md
```

Expected: PASS

### Step 2: Commit

```bash
git add .github/workflows/docker-publish.yml \
  tests/test_docker_publish_workflow.py \
  ARCHITECTURE.md \
  docs/plans/2026-03-11-multi-arch-images-design.md \
  docs/plans/2026-03-11-multi-arch-images.md
git commit -m "feat: publish multi-arch Docker images"
```
