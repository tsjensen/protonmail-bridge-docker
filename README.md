# protonmail-bridge-docker

Run [ProtonMail Bridge](https://protonmail.com/bridge/) in a Docker container.

## Prerequisites

- a [ProtonMail](https://protonmail.com/) account
- [Docker](https://www.docker.com/) (obviously)

## Setup

This repo is a fully functional setup, which only needs to be configured. The ProtonMail Bridge application is
downloaded as part of the Docker build.

1. Enter your ProtonMail email address and password into the file *credentials.txt*.
   > **Note:** The file must have UNIX line endings. Keep the single quotes, so that any special characters in your
     password don't cause trouble.

   Example:
   
       EMAIL='Your.Email@protonmail.com'
       PASSWORD='your_protonmail_password'

2. Build the docker image:

       docker build -t tsjensen/protonmail-bridge:1.2.2-1 .

   This will get you ProtonMail Bridge v1.2.2-1. If you want a different version, you can choose it via the
   `bridgeVersion` build argument:

       docker build --build-arg bridgeVersion=1.2.2-1 -t tsjensen/protonmail-bridge:1.2.2-1 .

## Run

In order to start the Bridge, run the container like this (*without* 2-factor authentication):

    docker run -p 25:25 -p 143:143 --name protonmail-bridge -d tsjensen/protonmail-bridge:1.2.2-1

If you use 2-factor authentication with ProtonMail, you must enter the MFA code via an extra parameter:

    docker run -p 25:25 -p 143:143 --name protonmail-bridge -e MFACODE=123456 -d tsjensen/protonmail-bridge:1.2.2-1

The bridge credentials for [configuring your email client](https://protonmail.com/bridge/clients) can be accessed via

    docker logs protonmail-bridge

Unless you change the port bindings, the URL for the IMAP service is `localhost:143`, and the SMTP one is
`localhost:25`.


## Credits

This Docker image is inspired by previous work by [Hendrik Meyer](https://gitlab.com/T4cC0re), who came up with a
clever workaround for wiring the network correctly using *socat* and *setcap* in his original
[protonmail-bridge-docker](https://gitlab.com/T4cC0re/protonmail-bridge-docker).

Later, while adding the topic tags to this GitHub repo, I found
[docker-protonmail-bridge](https://github.com/sdelafond/docker-protonmail-bridge) by
[S&eacute;bastien Delafond](https://github.com/sdelafond), which inspired improvements such as a smaller Docker image.
