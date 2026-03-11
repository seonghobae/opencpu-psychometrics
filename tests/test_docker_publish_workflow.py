import pathlib
import unittest


WORKFLOW = (
    pathlib.Path(__file__).resolve().parents[1]
    / ".github"
    / "workflows"
    / "docker-publish.yml"
)


class DockerPublishWorkflowTest(unittest.TestCase):
    def setUp(self) -> None:
        self.lines = WORKFLOW.read_text(encoding="utf-8").splitlines()

    def test_workflow_configures_qemu_before_buildx_for_multi_arch_images(self) -> None:
        qemu_setup = (
            "        uses: docker/setup-qemu-action@"
            "68827325e0b33c7199eb31dd4e31fbe9023e06e3 # v3.0.0"
        )
        buildx_setup = (
            "        uses: docker/setup-buildx-action@"
            "f95db51fddba0c2d1ec667646a06c2ce06100226 # v3.0.0"
        )

        self.assertIn(qemu_setup, self.lines)
        self.assertIn(buildx_setup, self.lines)
        self.assertLess(self.lines.index(qemu_setup), self.lines.index(buildx_setup))

    def test_workflow_builds_amd64_and_arm64_images(self) -> None:
        self.assertIn("          platforms: linux/amd64,linux/arm64", self.lines)


if __name__ == "__main__":
    unittest.main()
