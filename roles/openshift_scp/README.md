## Set Core User Password for Troubleshooting (Optional)

This section is completely optional but might be useful in the event network connectivity is lost to one of the OpenShift nodes. Here we will configure a password for the core user so we can login via the console if necessary.
The first step is to assign a hash password to the core user variable using the mkpasswd utlity. In our example we are passing in a password as the password. Choose a password that is appropriate for the organization's password policy.

