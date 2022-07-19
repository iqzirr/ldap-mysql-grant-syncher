# LDAP MySQL Grant Syncher

## Usage
To use the script, make sure that we have custom attributes added to LDAP members (here i added database, and databasePermission).


![image](https://user-images.githubusercontent.com/70002495/179700832-7dd73cc7-f5b3-4c9a-8ff4-61b435ccfb45.png)

After that, configure the Env Variables.
We can use the Dockerfile for the Docker-based app, ie:

![image](https://user-images.githubusercontent.com/70002495/179705993-99396aba-8b93-44a5-b123-03b7788f8071.png)

If you don't want to run it as a container, you can use it as a crontab, with exported Envs.
