![Terraform_BlogImage](https://github.com/user-attachments/assets/ac8e5635-c116-41bb-8c99-7a693997f3cb)


## Terraform Provisioner  | Remote-Exec 🚀



🎯  Key Features
```
✅ Provisioners can be used to model specific actions on the local machine or on a remote machine in order to prepare servers or other infrastructure objects for service
✅ The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource
✅ The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. To invoke a local process, see the local-exec provisioner instead. The remote-exec provisioner supports both ssh and winrm type connections.
✅ Most provisioners require access to the remote resource via SSH or WinRM, and expect a nested connection block with details about how to connect. Connection blocks don't take a block label, and can be nested within either a resource or a provisioner.
✅ The self object represents the provisioner's parent resource, and has all of that resource's attributes. For example, use self.public_ip to reference an aws_instance's public_ip attribute.
✅ Go to your local machine and run the following command.
```

🚀 
```
terraform init
terraform validate
terraform plan -var-file="template.tfvars"
terraform apply -var-file="template.tfvars" -auto-approve
```

🧩 Config 

```
scp -i ~/.ssh/<your pem file> <your pem file> ec2-user@<terraform instance public ip>:/home/ec2-user
chmod 400 <your pem file>
```

