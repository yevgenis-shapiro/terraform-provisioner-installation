

## Terraform Provisioners | 🚀


## Key Feature

 ```
    Provisioners can be used to model specific actions on the local machine or on a remote machine in order to prepare servers or other infrastructure objects for service.

    The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource.

    The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. To invoke a local process, see the local-exec provisioner instead. The remote-exec provisioner supports both ssh and winrm type connections.

    The file provisioner is used to copy files or directories from the machine executing Terraform to the newly created resource. The file provisioner supports both ssh and winrm type connections.

    Most provisioners require access to the remote resource via SSH or WinRM, and expect a nested connection block with details about how to connect. Connection blocks don't take a block label, and can be nested within either a resource or a provisioner.

    The self object represents the provisioner's parent resource, and has all of that resource's attributes. For example, use self.public_ip to reference an aws_instance's public_ip attribute.

    Take your pem file to your local instance's home folder for using remote-exec provisioner.

    Go to your local machine and run the following command.
```

scp -i ~/.ssh/<your pem file> <your pem file> ec2-user@<terraform instance public ip>:/home/ec2-user

    Or you can drag and drop your pem file to VS Code. Then change permissions of the pem file.

chmod 400 <your pem file>

    Create a folder name Provisioners and create a file name main.tf. Add the followings.

mkdir Provisioners && cd Provisioners && touch main.tf

