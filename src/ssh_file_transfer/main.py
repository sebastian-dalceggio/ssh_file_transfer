"""Main module."""

from pathlib import Path

from datatool.config import Config
from datatool.files.file_transfer_manager import FileTransferManager
from datatool.files.files import TextFile
from datatool.paths.ssh_path import SshPath
from terraform_utils.utils import get_terraform_output


def transfer_file_from_ec2():
    """
    Transfers a file from an EC2 instance to the local filesystem.

    The EC2 instance details (IP, private key) are retrieved from
    the Terraform output variables.
    """
    project_root = Path(__file__).parent.parent.parent
    terraform_dir = project_root / "terraform"
    storage_dir = project_root / "storage"
    storage_dir.mkdir(exist_ok=True)

    print("-> Retrieving infrastructure details from Terraform outputs...")
    server_ip = get_terraform_output("instance_public_ip", terraform_dir)
    private_key_path = get_terraform_output("private_key_file", terraform_dir)
    print(f"   - EC2 Instance IP: {server_ip}")
    print(f"   - Private Key Path: {private_key_path}")

    user = "ec2-user"
    remote_file_path = f"/home/{user}/test.txt"
    local_file_path = storage_dir / "test.txt"

    config = Config(storage_parent_path=storage_dir)

    source_path = SshPath(
        f"ssh://{user}@{server_ip}{remote_file_path}",
        private_key_path=private_key_path,
    )
    source_file = TextFile(config=config, path_or_name=source_path)

    target_file = TextFile(config=config, path_or_name=local_file_path)

    print("\n-> Starting file transfer from EC2 to local storage...")
    try:
        transfer_manager = FileTransferManager(config=config)
        transfer_manager.transfer_file(source_file, target_file)
        print(f"\nSuccess! File transferred to: {target_file.path.resolve()}")
    except Exception as e:
        print("Error: File transfer failed.")
        raise e


if __name__ == "__main__":
    transfer_file_from_ec2()
