# Readme

## ENV Variables
* All are required  
ORTRAX_WEB_ID  
ORTRAX_WEB_PASSWORD  
ORTRAX_API_KEY  
JIRA_ID  
JIRA_PASSWORD  
JIRA_URL  
JIRA_PROJECT_KEY  

* ENV are provided via a file called ".env" which belongs in the same folder as
  the Dockerfile.
  - Define variables in this format, one per line: `JIRA_ID=jira@email.com`
  - Docker image should be run with "env-file" option, such as:
    `docker run --env-file=.vars -i -t image_name /bin/bash`

## Notes
### Commands
- `sudo docker build . --tag=ortrax1`
  * build
- `sudo docker run --env-file=.env -i -t ortrax1 /bin/bash`
  * Get a terminal. Tester can be found at `/usr/app/test_all_cases.rb`
- `sudo docker run --env-file=.env -i -t ortrax1 ruby /usr/app/test_all_cases.rb`
  * Run the tester
