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
        self.content = WORKFLOW.read_text(encoding="utf-8")
        self.lines = self.content.splitlines()

    def test_workflow_configures_qemu_before_buildx_for_multi_arch_images(self) -> None:
        qemu_marker = "uses: docker/setup-qemu-action@"
        buildx_marker = "uses: docker/setup-buildx-action@"

        qemu_index = next(
            index for index, line in enumerate(self.lines) if qemu_marker in line
        )
        buildx_index = next(
            index for index, line in enumerate(self.lines) if buildx_marker in line
        )

        self.assertIn(qemu_marker, self.content)
        self.assertIn(buildx_marker, self.content)
        self.assertLess(qemu_index, buildx_index)

    def test_workflow_builds_amd64_and_arm64_images(self) -> None:
        self.assertIn("platforms:", self.content)
        self.assertIn("linux/amd64", self.content)
        self.assertIn("linux/arm64", self.content)


if __name__ == "__main__":
    unittest.main()
