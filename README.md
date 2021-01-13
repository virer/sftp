# SFTP

![OpenSSH logo](https://raw.githubusercontent.com/virer/sftp/master/openssh.png "Powered by OpenSSH")

## Securely share your files

Easy to use SFTP ([SSH File Transfer Protocol](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol)) server with [OpenSSH](https://en.wikipedia.org/wiki/OpenSSH).

Original work from atmoz (https://github.com/atmoz/sftp) <br>
Modified by S.CAPS for OpenShift 4 compatibility <br>

### Note:
- This container need to modify the OpenShift Security Context (scc) as anyuid for the used service-account
- alpine part removed
- This as been tested on OpenShift 4.5 with only one user

## OpenShift 4 usage:
- Create a service account inside your namespace/project (example: sftp-sa)
- Change the Security Context for this serviceAccount to allow the pod to run as root using the following command:
   `$ oc adm policy add-scc-to-user anyuid -z my-sftp-service-account`
- Create a config map containing your user list
- Create a service to expose sftp using a NodePort (since Routes are for http(s) traffic)
- Create a persitent volume to save your datas
- Deploy the pod using the previously created serviceAccount, service, config-map and pv

I've provided OpenShift 4 examples in the openshift directory of the project.

## Logging in / How to access it on OpenShift 4 ?
Since there is no OpenShift Route to access your SFTP service (no http(s) traffic), <br>
you need to point to the any worker of your OpenShift cluster using the nodePort number used at the OpenShift Service. <br>
Here, in the example, I use 30922. So you can use your SFTP client like that:  <br>
    `$ sftp -P 30922 your-username@worker1.fqdn.domain.tld` <br>
    even if the pod is running worker2 for example <br>
    (all worker port number 30922 will redirect to the right pod :))<br>

## Users list format:

users.conf:

```
foo:123:1001:100
bar:abc:1002:100
baz:xyz:1003:100
```

## Encrypted password using the tag ":e" after the encrypted password :
You can use makepasswd (sudo apt install makepasswd) to generate encrypted passwords:  
`echo -n "your-password" | makepasswd --crypt-md5 --clearfrom=-`

foo:$1$9KJP0cS4$jTgAq1Q7l2OdF9CqAXGNw.:e:1001


## Logging in with SSH keys

Mount public keys in the user's `.ssh/keys/` directory. All keys are automatically appended to `.ssh/authorized_keys` (you can't mount this file directly, because OpenSSH requires limited file permissions). In this example, we do not provide any password, so the user `foo` can only login with his SSH key.

## Tip: you can generate your own sshd host keys with these commands:

```
ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null
ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null
```

## Todo
  - For consistent server fingerprint, mount your own host keys (i.e. `/etc/ssh/ssh_host_*`) inside the pod

Original work from atmoz (https://github.com/atmoz/sftp) <br>
Modified by S.CAPS for OpenShift 4 compatibility <br>