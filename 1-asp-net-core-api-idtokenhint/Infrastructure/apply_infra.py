import subprocess
import sys
import shutil

# Terraform directory
TERRAFORM_DIR = "./Infrastructure/azure"  # adjust to your Terraform code folder

def check_terraform():
    """Check if Terraform binary is available"""
    if shutil.which("terraform") is None:
        print("Error: Terraform not found in PATH.")
        sys.exit(1)

def parse_cli_args(args):
    """
    Parse arguments like ip=1.2.3.4 into a dict
    """
    tf_vars = {}
    for arg in args:
        if "=" in arg:
            key, value = arg.split("=", 1)
            tf_vars[key] = value
    return tf_vars

def parse_cli_args(args):
    """
    Parse CLI args like: plan ip=1.2.3.4 db_password=xxx
    Returns:
        command: terraform subcommand (plan/apply/destroy)
        tf_vars: dict of key=value variables
    """
    if not args:
        print("Usage: python apply_infra.py <command> [var=value ...]")
        sys.exit(1)

    command = args[0]
    tf_vars = {}
    for arg in args[1:]:
        if "=" in arg:
            key, value = arg.split("=", 1)
            tf_vars[key] = value
    return command, tf_vars


def run_terraform_command(command, tf_vars=None):
    """Run Terraform command with optional variables"""
    cmd = ["terraform", f"-chdir={TERRAFORM_DIR}", command]

    # For 'apply' and 'destroy', auto-approve
    if command in ["apply", "destroy"]:
        cmd.append("-auto-approve")

    # Add -var flags
    if tf_vars:
        for key, value in tf_vars.items():
            cmd.append(f'-var={key}="{value}"')

    print(f"\nRunning: {' '.join(cmd)}\n")

    try:
        result = subprocess.run(
            cmd,
            text=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
    except subprocess.CalledProcessError as e:
        print("Terraform command failed!")
        print("STDOUT:\n", e.stdout)
        print("STDERR:\n", e.stderr)
        sys.exit(1)

    print("STDOUT:\n", result.stdout)
    print("STDERR:\n", result.stderr)

if __name__ == "__main__":
    check_terraform()

    # Parse CLI args
    command, tf_vars = parse_cli_args(sys.argv[1:])

    # Run Terraform command
    run_terraform_command(command, tf_vars)
