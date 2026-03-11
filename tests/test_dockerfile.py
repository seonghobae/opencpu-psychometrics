import pathlib
import unittest

DOCKERFILE = pathlib.Path(__file__).resolve().parents[1] / "Dockerfile"


class DockerfileBuildStabilityTest(unittest.TestCase):
    def setUp(self) -> None:
        self.content = DOCKERFILE.read_text(encoding="utf-8")

    def test_r_package_install_does_not_use_all_detected_cores(self) -> None:
        self.assertNotIn("parallel::detectCores()", self.content)
        self.assertIn("ARG R_INSTALL_NCPUS=2", self.content)
        self.assertIn("Sys.getenv('R_INSTALL_NCPUS')", self.content)

    def test_bioconductor_install_disables_global_updates(self) -> None:
        install_statements = [
            statement.strip()
            for statement in self.content.split(";")
            if "BiocManager::install(" in statement
        ]
        self.assertTrue(
            install_statements, "expected BiocManager::install call in Dockerfile"
        )
        self.assertTrue(
            all("update = FALSE" in statement for statement in install_statements),
            "expected every BiocManager::install call to pin update = FALSE",
        )


if __name__ == "__main__":
    unittest.main()
