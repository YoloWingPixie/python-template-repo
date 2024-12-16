import sys
import logging
import platform
import shutil
import subprocess
import os

class CLIApplication:
    """
    A command-line application template with common utility methods.
    """

    def __init__(self):
        """
        Initializes the application and sets up logging.
        """
        self.application_name = "CLIApplication"
        self.logger = self.setup_logger()

    def setup_logger(self):
        """
        Configures logging for the application to log to the console and a file.
        """
        logger = logging.getLogger( self.application_name)
        logger.setLevel(logging.DEBUG)
        console_handler = logging.StreamHandler()
        file_handler = logging.FileHandler("application.log")
        formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
        console_handler.setFormatter(formatter)
        file_handler.setFormatter(formatter)
        logger.addHandler(console_handler)
        logger.addHandler(file_handler)
        return logger

    def detect_platform(self):
        """
        Detects and returns the platform the script is running on.
        """
        return platform.system()

    def version(self):
        """
        Returns the version number of the script as a string.
        """
        return "1.0.0"

    def get_env_variable(self, name, default=None):
        """
        Retrieves the value of an environment variable, logging a warning if not found.
        """
        value = os.environ.get(name, default)
        if value is None:
            self.logger.warning(f"Environment variable '{name}' not found.")
        return value

    def execute_shell_command(self, command, wait=True):
        """
        Executes a shell command. Waits for completion if 'wait' is True.
        """
        try:
            if wait:
                result = subprocess.run(command, check=True, shell=True)
                return result.returncode
            else:
                subprocess.Popen(command, shell=True)
        except subprocess.CalledProcessError as e:
            self.logger.error(f"Command '{command}' failed with error: {e}")
            return e.returncode

    def copy_file(self, src, dst):
        """
        Copies a file from src to dst. Logs an error if the operation fails.
        """
        try:
            shutil.copy(src, dst)
            self.logger.info(f"Copied file from {src} to {dst}.")
        except FileNotFoundError:
            self.logger.error(f"Source file '{src}' not found.")
        except Exception as e:
            self.logger.error(f"Failed to copy file: {e}")

    def self_test(self):
        """
        Performs a basic self-test to verify functionality.
        """
        self.logger.info("Running self-test...")
        try:
            assert self.get_version() == "1.0.0"
            assert self.detect_platform() in ["Linux", "Windows", "Darwin"]
            self.logger.info("Self-test passed.")
        except AssertionError:
            self.logger.error("Self-test failed.")
            return False
        return True

    def usage(self):
        """
        Prints usage information for the application.
        """
        usage_text = f"""
        { self.application_name } - A command-line application template.

        Usage:
            python cli_application.py [options]

        Options:
            --help          Show this help message.
            --test          Run a self-test.
            --version       Show application version.
        """
        print(usage_text)

    def main(self, argv):
        """
        Main entry point for the application. Processes command-line arguments.
        """
        if len(argv) < 2:
            self.print_usage()
            return 1

        if "--help" in argv:
            self.print_usage()
        elif "--test" in argv:
            return 0 if self.run_self_test() else 1
        elif "--version" in argv:
            print(f"{ self.application_name } version {self.get_version()}")
        else:
            self.logger.error("Invalid option. Use --help for usage information.")
            return 1

        return 0


if __name__ == "__main__":
    app = CLIApplication()
    sys.exit(app.main(sys.argv))
