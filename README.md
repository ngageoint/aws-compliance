# aws-compliance

To enforce organizational standards on your AWS instances, put this script in a root user cron of your orginizations AMI like below.

```
sudo crontab -e
@reboot /var/lib/cloud/scripts/per-boot/onyd.sh
````

Then place this script under /var/lib/cloud/scripts/per-boot and ensure executable.

`sudo chmod +x /var/lib/cloud/scripts/per-boot/onyd.sh`

For email notifications to work, ensure the mail package is installed by running the command `sudo yum install mailx` on the instance before making it an AMI.

## How It Works

Upon creation of a new instance off the AMI, the cron runs this script that looks at AWS's meta data url (http://169.254.169.254/1.0/meta-data/) to check if the instance was launched with orginization settings. If the required values are not found, the instance is powered off leaving those with power to create instances in AWS wondering why their machine keeps shutting off. Eventually, they will learn to keep the machine from shutting down they need to follow the compliance process.

This all happens within the first minute of the instances creation so as to not give users enough time grow a dependency on the instance. Here is the list of settings the script looks for:
- appropriate domain name
- central SSH key
- list of security groups

The supported orginizational settings checked are stored in a bash associative array. Right now they are set to my Org's values. To tailor to your desires, download the script, crack it open, and modify the values in the array named "CHECK".
