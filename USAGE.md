# Usage

This document provides a few examples of possible requests to the APIs.

## Health checks

To check the health status of the `feeds management service`:

```bash
curl -i http://localhost:9000/api/v1/healthcheck
```

To check the health status of the `articles management service`:

```bash
curl -i http://localhost:9001/api/v1/healthcheck
```

For both requests you should get a 200 status code and a response like this:

```json
{
  "status": "OK"
}
```

---

## Feeds management requests

To get a list of feeds (by default it will only return enabled feeds):

```bash
curl -s http://localhost:9000/api/v1/feeds | jq .
```

This call supports 3 optional query parameters that act as a filter: `enabled` which is set to true by default, `provider` and `category`.

Example response:

```json
[
  {
    "url": "http://feeds.bbci.co.uk/news/technology/rss.xml",
    "provider": "BBC News",
    "category": "Technology"
  },
  {
    "url": "http://feeds.bbci.co.uk/news/uk/rss.xml",
    "provider": "BBC News",
    "category": "UK"
  },
  {
    "url": "http://feeds.skynews.com/feeds/rss/technology.xml",
    "provider": "Sky News",
    "category": "Technology"
  },
  {
    "url": "http://feeds.skynews.com/feeds/rss/uk.xml",
    "provider": "Sky News",
    "category": "UK"
  }
]
```

To add a new feed:

```bash
curl -i -X POST http://localhost:9000/api/v1/feeds -d '{"url": "<FEED_URL_HERE>", "provider": "<FEED_PROVIDER_HERE>", "category": "<FEED_CATEGORY_HERE>"}' | jq .
```

To enable/disable a feed:

```bash
curl -i -X PUT http://localhost:9000/api/v1/feeds/<FEED_URL_HERE> -d '{"enabled": false}' | jq .
```

To remove a feed:

```bash
curl -i -X DELETE http://localhost:9000/api/v1/feeds/<FEED_URL_HERE>
```

---

## Articles management requests

To get a list of articles:

```bash
curl -s http://localhost:9001/api/v1/articles | jq .
```

To add a new article:

```bash
curl -i -X POST 'http://localhost:9001/api/v1/articles' -d '{"guid":"guid1", "title": "title1", "description": "desc1", "link": "link1", "provider": "provider1", "category": "category1", "published_date": "2020-05-10T10:00:00+02:00"}'
```
