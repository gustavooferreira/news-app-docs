# Usage

In this document there are a few examples of possible requests to the APIs.

## Health checks

To check the health status of the `feeds management web service`:

```bash
curl -s http://localhost:9000/api/v1/healthcheck | jq .
```

To check the health status of the `articles management web service`:

```bash
curl -s http://localhost:9001/api/v1/healthcheck | jq .
```

For both requests you should get a response like this:

```json
{
  "status": "OK"
}
```

---

## Feeds management requests

To get a list of feeds:

```bash
curl -s http://localhost:9000/api/v1/feeds | jq .
```

This call supports an optional query parameter, that acts as a filter, `enabled` which is set to true by default.

To add a new feed:

```bash
curl -X POST -s http://localhost:9000/api/v1/feeds -d '{"url": "<FEED_URL_HERE>", "provider": "<FEED_PROVIDER_HERE>", "category": "<FEED_CATEGORY_HERE>"}' | jq .
```

To remove a feed:

```bash
curl -X DELETE -s http://localhost:9000/api/v1/feeds/<FEED_URL_HERE> | jq .
```

To enable/disable a feed:

```bash
curl -X PUT -s http://localhost:9000/api/v1/feeds/<FEED_URL_HERE> -d '{"enabled": false}' | jq .
```

---

## Articles management requests

To get a list of articles:

```bash
curl -s http://localhost:9001/api/v1/articles | jq .
```
