# step-gcr-auth
Wercker step for generating a temporary gcr.io authentication. The generated token is stored in the `GCR_AUTH_TOKEN` environment variable.

# Options

- `account` The Google Cloud service account
- `refresh_token` The Google Cloud service account refresh token

# Example

```yaml
deploy:
  steps:
    - appnific/gcr-auth:
        account: <MY-GCLOUD-SERVICE-ACCOUNT>
        refresh_token: <MY-GCLOUD-REFRESH-TOKEN>
    - internal/docker-push:
        username: _token
        password: $GCR_AUTH_TOKEN
        repository: gcr.io/<MY-PROJECT>/<MY-IMAGE>
        registry: https://gcr.io
```

# License

The MIT License (MIT)
