# gce-ctf
some deployment tools to run CTF challenges on GCE

# prerequisites
* [the google cloud sdk](https://cloud.google.com/sdk/downloads)
* create a new project at https://console.cloud.google.com
* set your project id: `gcloud config set project $PROJECT_NAME`

# example
```sh
# create_vm.sh takes an id as the first parameter. The VM will be called ctf-1
# there are more optional arguments. Run it to see the usage
./create_vm.sh 1 
# list_vms.sh will print you all existing VMs, convenient to get the public IP
IP=$(./list_vms.sh | tail -n 1 | awk '{print $5}')
cd example
# run_chal.sh [zone] VM_name config.file
../deploy_tools/run_chal.sh "" ctf-1 example.config

nc $IP 1337
```

# create a challenge
Just take a look at `example/example.config`.
* You have to specify
 * the challenge name
 * port
 * files
 * an install script
* All files, including the flag will be created at /chals/$chal_name on the host and mounted in /home/user/ in the challenge VM
* The user id of the challenge user is 427680
