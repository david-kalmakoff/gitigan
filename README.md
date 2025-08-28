# Gitigan

Is a web application that allows you to host a single backend for multiple web application forms.

You can register a form on Gitigan and then use it on any web application.

Then you do not have to include a backend to handle form requests on each web application.

I built this application because I got tired of having to create a backend for each web application that simply handled form requests and sent emails accordingly.

## Features

- OAuth2 authentication with [Pocket ID](https://pocket-id.org/)
- Admin interface to manage forms
- Emails are send using SMTP

## Demo

A demo of Gitigan is available at [Demo](https://gitgan.davidkalmakoff.com).

## Deployment

### Docker Compose

```yaml
services:
  gitgan:
    image: web:latest
    ports:
      - 4000:4000
    volumes:
      - gitigan:/data
    depends_on:
      - pocket_id
    environment:
      - POCKET_CLIENT_ID=${POCKET_CLIENT_ID}
      - POCKET_CLIENT_SECRET=${POCKET_CLIENT_SECRET}
      - POCKET_REDIRECT_URI=${POCKET_REDIRECT_URI}
      - POCKET_SITE=${POCKET_SITE}
      - POCKET_AUTHORIZE_URL=${POCKET_AUTHORIZE_URL}
      - POCKET_TOKEN_URL=${POCKET_TOKEN_URL}

  pocket_id:
    image: pocket-id:latest
    ports:
      - 8080:8080
    volumes:
      - pocket_id:/data

volumes:
  gitigan:
  pocket_id:
```

### Environment variables

| Variable               | Description                 |
| ---------------------- | --------------------------- |
| `POCKET_CLIENT_ID`     | Client ID for Pocket ID     |
| `POCKET_CLIENT_SECRET` | Client Secret for Pocket ID |
| `POCKET_REDIRECT_URI`  | Redirect URI for Pocket ID  |
| `POCKET_SITE`          | Site for Pocket ID          |
| `POCKET_AUTHORIZE_URL` | Authorize URL for Pocket ID |
| `POCKET_TOKEN_URL`     | Token URL for Pocket ID     |

## Development
