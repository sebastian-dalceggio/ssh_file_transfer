# SSH File Transfer Example

This project demonstrates how to transfer a file from a remote EC2 instance to a local filesystem and a Google Cloud Storage bucket using Python and SSH. All the necessary AWS y Google Cloud infrastructure is provisioned using Terraform.

## Overview

The project consists of two main parts:

1.  **Terraform Infrastructure**: A set of Terraform configurations that create the following AWS and GC resources:
    *   A VPC with a public subnet, Internet Gateway, and route table.
    *   An EC2 instance (t2.micro) running Amazon Linux 2.
    *   A security group that allows SSH access from your current public IP.
    *   An SSH key pair, with the private key saved to your local `~/.ssh/` directory.
    *   A user data script on the EC2 instance that creates a sample file (`/home/ec2-user/test.txt`).
    *   A Cloud Storage bucket.

2.  **Python File Transfer Script**: A Python script that:
    *   Retrieves the public IP of the created EC2 instance from the Terraform outputs.
    *   Uses the `datatool` library to establish an SSH connection.
    *   Transfers the `test.txt` file from the EC2 instance to the local `./storage/` directory and the Cloud Storage Bucket.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

-   AWS CLI: Configured with your credentials (`aws configure`).
-   Google Cloud credentials file in GC_CREDENTIALS path.
-   Terraform (v1.0.0 or later).
-   Python (v3.12 or later).
-   uv (or pip) for Python package management.

## Setup

1.  **Clone the repository (if you haven't already):**
    ```sh
    git clone https://github.com/sebastian-dalceggio/ssh_file_transfer.git
    cd ssh_file_transfer
    ```

2.  **Install Python dependencies:**
    It's recommended to use a virtual environment.
    ```sh
    python -m venv .venv
    source .venv/bin/activate
    uv pip install -e .
    ```

## Usage

1.  **Deploy the Infrastructure**
    Navigate to the terraform directory, initialize, and apply the configuration.
    ```sh
    terraform -chdir=terraform init
    terraform -chdir=terraform apply -auto-approve
    ```
    This will create all the AWS resources and save the private key to `~/.ssh/ssh_file_transfer_private_key`.

2.  **Transfer the File**
    Run the Python script to perform the file transfer.
    ```sh
    python src/ssh_file_transfer/main.py
    ```
    You will see output indicating the server IP and the transfer progress. The file will be downloaded to `./storage/test.txt`.

## Cleanup

To avoid incurring further charges, destroy the AWS resources when you are finished.

```sh
terraform -chdir=terraform destroy -auto-approve
```

