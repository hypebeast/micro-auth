# micro-auth

A microservice that makes adding authentication with Google or Github to your application easy.

This service allows you to use Google and Github OAuth2 service to add authentication to your applications in a very straightforward way.

It's build with [Nginx/OpenResty](https://openresty.org/en/), [Lapis](http://leafo.net/lapis/) and [Docker](https://www.docker.com/). This enables the service to be very performant and requires only minimal system resources.


## Features

  * Use [Google](https://developers.google.com/identity/protocols/OAuth2) or [Github](https://developer.github.com/v3/oauth/) OAuth2 authentication to provide a simple login mechanism for your application.
  * Quick setup with [Docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/). With support for development and production environments.
  * Based on [Lapis](http://leafo.net/lapis) and [Nginx/OpenResty](https://openresty.org/en/).


## Getting started

  * Install (if you don't have them):
    * [Docker](https://www.docker.com/)
    * [docker-compose](https://docs.docker.com/compose/)
  * Setup required [environment variables](#environment-variables)
  * Run in _development_ mode:
    * Run the application with `docker-compose -f docker-compose-dev.yml up`
  * Run in _production_ mode:
    * Run the application with `docker-compose up`
  * Once `micro-auth` is running, you can point your login to one of the following urls (URLs are for development mode):
    * `http://localhost:8080/auth/github`: For Github login
    * `http://localhost:8080/auth/google`: For Google login


## Authentication Services

### Google

**Setup**

Visit [Google Developers Console](https://console.developers.google.com) and create a new application on Google.
Then go to [Credentials](https://console.developers.google.com/apis/credentials) and create a new _OAuth Client ID_.
Now, get the _Client ID_ and _Client secret_.

**Endpoints**

  * `http://localhost:8080/auth/google`: Endpoint for Google authentication. Point your application to this endpoint to login with Google.

**Results**

After successfull authentication with Google the user is redirect to the URL specified in `GOOGLE_REDIRECT_URL` with the access token saved in the `access_token` query parameter.

### Github

**Setup**

Visit [Github](https://github.com/settings/applications/new) and create a new application on Github to get your client id and secret.

**Endpoints**

  * `http://localhost:8080/auth/github`: Endpoint for Github authentication. Point your application to this endpoint to login with Github.

**Results**

After successfull authentication with Github the user is redirect to the URL specified in `GITHUB_REDIRECT_URL` with the access token saved in the `access_token` query parameter.


## Environment variables

To use the service you must set some required environment variables. These variables can be set in the `.env` file. Just copy `.env.example` to `.env`

```
$ cp .env.example .env
```

end set the required variables.

## Secrets in docker swarm
Setting the above environment variables with `_FILE` pointed at the secret mount inside the container. `-e GOOGLE_SECRET_FILE=/run/secrets/google_secret`. This will set the contents on the file as the value of the environment variable.

### General

  * `APP_URL`: Specify the URL of `micro-auth` (default: `http://localhost:8080` in development mode). The `APP_URL` must be set in production mode.

### Google

  * `GOOGLE_CLIENT_ID`: The Google application client id (required)
  * `GOOGLE_CLIENT_SECRET`: The Google application client secret (required)
  * `GOOGLE_REDIRECT_URL`: The url to redirect the user once the authentication was successfull

### Github

  * `GITHUB_CLIENT_ID`: The Github application client id (required)
  * `GITHUB_CLIENT_SECRET`: The Github application client secret (required)
  * `GITHUB_REDIRECT_URL`: The url to redirect the user once the authentication was successfull


## License

See [LICENSE](./LICENSE)


## Credits

  * [micro-github](https://github.com/mxstbr/micro-github)
