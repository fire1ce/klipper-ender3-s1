# Work in progress

There are many Github api requests made by the setup. To avoid the rate limit its best to Authenticate with Github.
Follow the documentation to create a Personal Access Token and use it to authenticate the requests.

Create a new token with default,read-only permissions (do not check any boxes) at:

- [Github Personal access tokens (classic)](https://github.com/settings/tokens/new/)

Copy and save the token as you will not be able to see it again!

```shell
curl -u "fire1ce" https://api.github.com
```

Reference Documentation:

- [Creating a Personal Github Access Token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

- [Authenticating to he Github's Rest API](https://docs.github.com/en/rest/overview/authenticating-to-the-rest-api)

- [Kiauh](https://github.com/th33xitus/kiauh)
