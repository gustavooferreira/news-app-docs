# Design Document

The `News App system` has been split into smaller functional services that have only one responsibility.

The `feeds management service` keeps track of the RSS feeds.

The `articles management service` keeps track of all metadata of all articles for all providers.

The `fetcher service` is responsible for periodically fetching new articles from the RSS providers.

![diagram](images/bin/logical_diagram.png)

## System operation

As I've said above this system is made up of 3 services.

The `feeds management service` which is responsible for keeping track of which RSS feeds our applications pulls data from, is built as a simple CRUD API on top of MySQL.

The `articles management service` which is responsible for collecting all the articles metadata from all providers, is also a simple CRUD API on top of MySQL.

Finally, the `fetcher service` which is responsible for actually talking to the RSS feed providers, is a simple service that every X minutes/hours (configurable) will fetch new articles from all RSS feed URLs.

The way the `fetcher service` works is as follows:

- Tick timer triggered
- Send request to `feeds management service` to get a list of all the RSS feeds it needs to pull data from
- Fetch data from all RSS feeds
- Send all data to the `articles management service`

There are better ways to accomplish this, I could for example have the fetcher talk to the articles management service to get all the latest articles publish date for all the providers and then when we get the data back from the RSS feed we could choose to send only the new articles to the `articles management service`. This would be a much better way of doing it.

But I've decided to just "dump" all the data into the `articles management service` and let it discard the data that it already has. If this was a service in production, I wouldn't do it like this. Also because this approach puts more unnecessary pressure onto the `articles management service` to sort out the data it gets.

## Design decisions

I decided to use a relational database for storing the articles metadata as I believe it lands itself well for this type of service given all we need is a place with a simple and clear structure to store data we get from the RSS feeds.

I also decided to use a relational database for the feeds management service as all we need is a persistent storage with minimal look up capabilities.

In any case, we could have chosen a document store, like MongoDB, or even a wide column store, like Cassandra, for any of these services. Since this is a fairly simple service I don't believe database choice, in this case, matters too much.

We'd have to consider this further if we were planing on growing this service, but at that point, we would most certainly have more requirements or at least an idea of the future features we would want these services to have, which would in turn provide more clarity on which database would make more sense for each service.

A note goes to the fact that both the `feeds management service` and the `articles management service` could have been combined. This would be perfectly valid as they are both related. I decided to split them because I wanted to have 3 services instead of 2, which shouldn't be a reason to decide to split a service in the first place, but this is just an exercise.

## Development decisions

There is code in some of these services that could be reused and therefore, in a production grade codebase I'd most definitely be moving that code into their own libraries.

Some examples of that are: logging setup and their corresponding interfaces and implementation, configuration setup (in this case I'd rather use a library like Viper).

I have not escaped the fields used on the SQL statements because I'm using GORM. GORM already escapes all fields in certain conditions, but certainly not all. [See this](https://gorm.io/id_ID/docs/security.html).

## API design decisions

For both APIs we start off with the API version in the path. There are a few ways of versioning APIs, I personally like this method more.

On the `articles management service` API, one of the endpoints has the path `/articles:batch` with the HTTP method `POST`. This is inline with the [google API design guide](https://cloud.google.com/apis/design/custom_methods).

Still on the `articles management service` API, there is another endpoint to get a list of articles metadata. This endpoint is paginated and uses the keyset pagination technique based on the published time.

The way this works in the articles API is, the user gets the X number of articles (max is set to 200 to avoid abusing the service), and then looks for the last article's published date and supplies that on the next call. When the user receives less articles than the number requested, it means the user has reached the end.

I could have provided a nicer mechanism to let the API client know when we don't have any more records, especially because if the number of records in the database is a multiple of the number supplied as the `limit` i.e., the number of articles to receive on each call, it means the API client will have to make an extra call in the end and receive an empty response to realise there are no more articles.

Another thing I would like to point out is that, the `article management` API only allows to filter by one provider at a time. I could have improved this by having a query parameter called `providers` instead and have the ability for clients to pass several providers, comma separated, in that query parameter. Same goes for the `category` query parameter.

## Git workflow

Normally, I have 3 branches `master`, `test` and `develop` and I usually branch off `develop` to implement features. I then commit frequently to those feature branches and just before merging them I squash all commits in the feature branch into one, so the commit represents one unit of work.

For this project, I will not be doing that given the extra work and the fact that I'm not collaborating with anyone else. Instead, I'll be committing frequently to the master branch.

This applies to all repos belonging to this project.

## Expansion and improvements

This service has no awareness of users preferences. I assume these are being kept in a different service.
If we were in charge of developing the whole application that supports the mobile app, then I'd add another service for user preferences and another one for authentication purposes.

Then, I'd add an extra API (let's call it `entry API`) that would take care of contacting all these services when the client makes a request.

For example: mobile app sends a request to `entry API` asking for all new articles since last time it contacted us. First, this request would have to include either a timestamp of the last time it contacted us or something else that would allow us to track when was the last request made.
Then, the `entry API` would first authenticate this request, then contact the user preferences services to get the list of RSS feeds this user had configured and then make a request to the articles management service to get all the latest articles and finally send a response back.

Fetcher is a service that could be greatly improved. I touched upon some points on the scalability section, but I want to mention a couple of them here. One feature I'd have liked to add is the ability to trigger a fetch asynchronously. Currently, as it stands the fetcher will periodically fetch the RSS feeds. If a user adds a new provider, we need to wait for the next cycle to start in order to see articles related to that provider. A better way of doing this would be to be able to trigger an async fetch to that provider.

Another thing we could improve on the fetcher is to leverage a PUSH service that would notify us of when new articles are available, to avoid the polling mechanism.

If this is not possible or undesirable, we can still improve the fetcher by making the polling time dynamic. Basically, we would have a timer for each provider/category and adjust it accordingly to the frequency of updates observed.

## Notes

Redis caching was not implemented, but if I were to add caching to the articles service, there are two ways we could go about doing this.
First, we can use a TTL for entries, after that TTL expires, entries in the cache would be removed. Second, instead of having a TTL, we could support explicit cache eviction. What this would mean is that, every time the fetcher got new articles, upon sending a request to the articles management service to add those new entries, the articles service could then evict entries in the cache related to those feeds providers/categories.

I'd do caching based on the filtering parameters.

I've recently discovered `groupcache`, created by the original memcached author, and I quite like what it has to offer, especially when it comes to not requiring external dependencies for caching purposes, not to mention replication of hot keys across different instances and what not.
However, because it doesn't have support for expiry time neither does it support explicit cache evictions, we would have to change our caching strategy to be able to use this service.

## High Availability and scalability

The picture below shows how we could scale each service independently.

![High availability](images/bin/ha.png)

We can scale the Feeds and Articles management services very easily by putting a load balancer in front of these services and having multiple instances of each service.

Both services are stateless simple CRUD services.

MySQL can be setup in a cluster to provide resiliency and so can Redis.

In the diagram I only show one MySQL cluster, as we would only setup a physical cluster and then have DB separation at the logical level.

As for the fetcher service, this one is trickier to scale. The problem is that at the moment, the fetcher service is setup in a way that it sends a request to each RSS url every X minutes/hours.

If we deploy several instances of this services, then they would all be doing the same work every time. Making unnecessary requests to the feed providers and not accomplishing much.

A better way to setup this service would be to split it into two components. One component's job is to fetch new articles from the feed providers and the other is responsible for queueing up work at a specific times for the fetcher to do the job. Here, we could use a distributed messaging queue system like kafka or rabbitMQ, but I have not detailed that in the diagram above.

With this setup we can have as many `fetcher` services as we would like and if one or more of them goes down, we continue to have a fully functional system.

With regards to the controller, which is the component that decides when to actually fetch for new updates, it's a bit trickier. Since we can only have one instance deciding at any given time when to trigger new jobs, we could have a sort of quorum being established between the controller instances and voting for who's the master at any given point in time. In that way, we guarantee that only one instance is queueing up jobs at any given point in time.

Another thing I'd add is an API so that we have the option to trigger fetches of RSS feeds asynchronously. One use case for this is when a user decides to add a new RSS URL, we could trigger an immediate fetch to that feed.

Finally, if we want to provide geo-resiliency we can use Anycast VIPs, and let BGP do the work.
