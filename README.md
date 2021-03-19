# News App Exercise - Documentation

This repository holds all documentation related to the News App System.

- [Design document](SYSTEM_DESIGN.md)
- [Setup guide](SETUP_GUIDE.md)
- [How to call the APIs](USAGE.md)

---

# API Specifications

The documentation of the APIs was created using OpenAPI (fka Swagger).

Please use [Swagger Editor](https://editor.swagger.io/) to visualize the API specs from the yaml files.

The easiest way to achieve this is by going to the website provided above and import one of the spec files linked below.

OpenAPI specs:

- [Feeds Management API Spec](openapi/feeds_mgmt_api_spec.yaml)
- [Articles Management API Spec](openapi/articles_mgmt_api_spec.yaml)

---

# Links to other repositories

This application was split into several repositories, below are the links to each one of them.

The names of the repositories are unnecessarily long because github doesn't support the concept of grouping like gitlab does.

Components:

- [Feeds Management Service](https://github.com/gustavooferreira/news-app-feeds-mgmt-service)
- [Articles Management Service](https://github.com/gustavooferreira/news-app-articles-mgmt-service)
- [Fetcher Service](https://github.com/gustavooferreira/news-app-fetcher-service)
