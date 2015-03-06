# PrimeTime Toran Proxy Docker Image

### Features
- non-priviliged user (alpha)
- environment based configuration
- ssh for git proxy
- automatically sets up location for mirrors
- generates mirror urls for toran config
- cron already set to run hourly
- based on phusion-baseimage

### Environment Variables
Key  | Value | Default
------------- | -------------
SECRET  | Secret | **
TORAN_SCHEME  | Protocol | http
TORAN_HTTP_PORT  | HTTP Port | 80
TORAN_HTTPS_PORT  | HTTPS Port | 443
TORAN_HOST | Hostname | **
TORAN_BASE_URL | Base URL | **
