# protonmail-bridge-docker

Run [ProtonMail Bridge](https://protonmail.com/bridge/) in a Docker container.

## Prerequisites

- a [ProtonMail](https://protonmail.com/) account
- [Docker](https://www.docker.com/) (obviously)
- The ProtonMail Bridge files for Linux. The Linux version of the ProtonMail Bridge is still in beta, so you must ask
  ProtonMail support to send you the files by email: `bridge@protonmail.com`

## Setup

Steps to build the working container image:

1. Place all the files received from ProtonMail into the *protonmail* folder, including files that you need to download,
   if any. There should be a .deb package, some keys and policy files, about 10 files total.

2. Enter your ProtonMail email address and password into the file *credentials.txt*.
   > **Note:** The file must have UNIX line endings. Keep the single quotes, so that any special characters in your
     password don't cause trouble.

   Example:
   
       EMAIL='Your.Email@protonmail.com'
       PASSWORD='your_protonmail_password'

3. Build the docker image:

       docker build -t tsjensen/protonmail-bridge:1.2.3-1 .

   This will get you ProtonMail Bridge v1.2.3-1. If you want a different version, you can choose it via the
   `bridgeVersion` build argument:

       docker build --build-arg bridgeVersion=1.2.3-1 -t tsjensen/protonmail-bridge:1.2.3-1 .


## Run

In order to start the Bridge, run the container like this (*without* 2-factor authentication):

    docker run -p 25:25 -p 143:143 --name protonmail-bridge -d tsjensen/protonmail-bridge:1.2.3-1

If you use 2-factor authentication with ProtonMail, you must enter the MFA code via an extra parameter:

    docker run -p 25:25 -p 143:143 --name protonmail-bridge -e MFACODE=123456 -d tsjensen/protonmail-bridge:1.2.3-1

The bridge credentials for [configuring your email client](https://protonmail.com/bridge/clients) can be accessed via

    docker logs protonmail-bridge

Unless you change the port bindings, the URL for the IMAP service is `localhost:143`, and the SMTP one is
`localhost:25`.


## License

This Docker image description is free software under the MIT license (see [LICENSE](LICENSE) file).  
Note that this project contains only the Dockerfile and some supplemental data. The ProtonMail Bridge application itself
is not part of this project. This project is not affiliated with ProtonMail. Any issues or concerns regarding the
ProtonMail Bridge should be addressed to the friendly folks at ProtonMail.


## Credits

This Docker image is inspired by previous work by [Hendrik Meyer](https://gitlab.com/T4cC0re), who came up with a
clever workaround for wiring the network correctly using *socat* and *setcap* in his original
[protonmail-bridge-docker](https://gitlab.com/T4cC0re/protonmail-bridge-docker).

Later, while adding the topic tags to this GitHub repo, I found
[docker-protonmail-bridge](https://github.com/sdelafond/docker-protonmail-bridge) by
[S&eacute;bastien Delafond](https://github.com/sdelafond), which inspired improvements such as a smaller Docker image.
