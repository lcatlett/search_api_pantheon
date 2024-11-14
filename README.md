# Search API Pantheon: Solr 8 & Drupal 9/10 Integration

[![Search API Pantheon](https://github.com/pantheon-systems/search_api_pantheon/actions/workflows/ci.yml/badge.svg?branch=8.x)](https://github.com/pantheon-systems/search_api_pantheon/actions/workflows/ci.yml)
[![Limited Availability](https://img.shields.io/badge/Pantheon-Limited_Availability-yellow?logo=pantheon&color=FFDC28)](https://pantheon.io/docs/oss-support-levels#limited-availability)

## Important Notice - Schema Reversion Prevention

Starting with version 8.1.x, this module includes critical fixes to prevent Solr schema reversions that could cause:

- Search functionality outages
- Loss of indexed content
- Unexpected schema reversions
- Site downtime

Users experiencing these issues should upgrade immediately to version 8.1.x-dev.

## Requirements

| Requirement     | Details                                                                                                                                      |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Drupal Version  | 9.4/10                                                                                                                                       |
| Hosting         | Pantheon platform                                                                                                                            |
| Site Management | Composer-based using either: <br> - Pantheon's integrated composer (`build step: true` in pantheon.yml) <br> - CI service (Circle CI/Travis) |
| Access          | Pantheon Dashboard                                                                                                                           |

## Intent

This module is meant to simplify the usage of [Search API](https://www.drupal.org/project/search_api) and [Search API Solr](https://www.drupal.org/project/search_api_solr) on [Pantheon](https://pantheon.io)'s Platform.

Search API Solr provides the ability to connect to any Solr server by providing numerous configuration options. This module automatically sets the Solr connection options by extending the plugin from Search API Solr. The module also changes its connection information based on different Pantheon environments and each Pantheon Environment has its own [SOLR CORE](#). Doing so eliminates the need to do extra work setting up Solr servers for each environment.

## What it provides

This module provides [Drupal 9](https://drupal.org) integration with the [Apache Solr project](https://solr.apache.org/guide/8_8/). Pantheon's current version as of the update of this document is 8.8.1.

## Composer

Composer is the way you should be managing your drupal module requirements. This module will install its dependencies when you use composer to install.

## Dependencies (installed by Composer):

- [Solarium](http://www.solarium-project.org/). Solarium is a Solr client library for PHP and is not Drupal-specific. First, register Drupal.org as a provider of Composer packages. This command should be run locally from the root directory of your Drupal 8 git repository.
- [Search API](https://www.drupal.org/project/search_api). Search API is Drupal's module for indexing content entities.
- [Search API Solr](https://www.drupal.org/project/search_api_solr). Search API Solr makes search API work with Apache Solr. Composer will manage which version.
- [Guzzle](https://docs.guzzlephp.org/en/stable/). Guzzle version 6 is standard with Drupal Core `9.x | 10.x` (read 9.x OR 10.x).

## Installation

### Stable Release

To install this module via composer, run the following command in your Drupal root:

```bash
composer require 'drupal/search_api_pantheon:^8.1'
```

### Development Version

Note that the above will install the latest stable release of this module. To install the latest development version, use:

```bash
composer require 'drupal/search_api_pantheon:8.1.x-dev@dev'
```

## Setup

### Platform Support

See [Drupal.org for complete documentation on Search API](https://www.drupal.org/node/1250878).

To configure the connection with Pantheon, perform the following steps on your Dev environment (or a Multidev):

1. **Enable Solr on your Pantheon site**

- Under "Settings" in your Pantheon site dashboard, enable Solr as an add on.
- This feature is available for sandbox sites as well as paid plans at the Professional level and above.

2. **Enable Solr 8 in your pantheon.yml file**

php_version: 8.1
database:
version: 10.4
drush_version: 10
search:
version: 8

### Core Reloading

#### Automatic Core Reload

Starting with version 8.1.x, Search API Pantheon automatically reloads the Solr core after schema updates to prevent schema reversions and maintain index integrity.

#### Schema Updates

Schema updates can be performed through:

- Admin UI: Navigate to `/admin/config/search/search-api/server/pantheon_solr8/pantheon-admin/schema`
- Drush: Run `drush search-api-pantheon:postSchema`

#### Manual Core Reload

If needed, manually reload the core using:

```bash
drush search-api-pantheon:reload
```

### Usage

1. **Enable the modules**

- Go to `admin/modules` and enable "Search API Pantheon."
- This will also enable Search API and Search API Solr if not already enabled.

2. **OPTIONAL: Disable Drupal Core's search module**

- If using Search API, you probably won't need Drupal Core's Search module.
- Uninstall it at `admin/modules/uninstall`.

3. **Verify server installation**

- Navigate to `CONFIG` => `SEARCH & METADATA` => `SEARCH API`
- Validate that the `PANTHEON SEARCH` server exists and is "enabled".

4. **Configure Solr schema**

- Navigate to `CONFIGURATION` => `SEARCH AND METADATA` => `SEARCH API` => `PANTHEON SEARCH` => `PANTHEON SEARCH ADMIN`
- Choose "Post Solr Schema"
- The module will post a schema specific to your site

### Using the server with an index

The following steps are not Pantheon-specific. This module only alters the configuration of Search API servers. To use a server, you next need to create an index.

1. Go to `admin/config/search/search-api/add-index`.
2. Name your index and choose a data source. If this is your first time using Search API, start by selecting "Content" as a data source.
3. Select "Pantheon" as the server.
4. Save the index.
5. Configure fields to be searched under the "fields" tab.
6. Index the content by clicking "Index now" or running cron.

### Searching the Index

1. Create a new view returning `INDEX PANTHEON SOLR8` of type 'ALL'.
2. Choose fields to include in the results.
3. Expose keywords for user search.
4. Sort by the "relevance" field for Solr's relevance rating.

### Exporting Changes

It's a best practice in Drupal 10 to export your changes to `yml` files. Using Terminus while in SFTP mode:

terminus drush PANTHEON_SITE.ENV config:export -y

### Optional Installs

Any of the optional `search_api` modules should work without issue with Pantheon Solr, including but not limited to:

- Search API Attachments
- Search API Facets
- Search API Autocomplete
- Search API Spellcheck
- Search API Ajax

## Pantheon Environments

Each Pantheon environment (Dev, Test, Live, and Multidevs) has its own Solr server. Indexing and searching in one environment does not impact any other environment.

## Troubleshooting

### Schema Reversion Issues

If you experience schema reversion issues:

1. Verify you're using version 8.1.x-dev or later
2. Check that core reloading is functioning after schema updates
3. Monitor the Drupal logs for schema update messages
4. Use `drush search-api-pantheon:diagnose` to verify configuration

### Common Issues

| Issue                       | Solution                                      |
| --------------------------- | --------------------------------------------- |
| Schema reverts unexpectedly | Ensure core reload is happening after updates |
| Search index corruption     | Try reposting schema and reindexing content   |
| Core reload failures        | Check Solr logs and connection status         |

### Diagnostic Commands

- `drush search-api-pantheon:diagnose` (`sapd`): Checks various pieces of the Search API install and reports errors.
- `drush search-api-pantheon:select` (`saps`): Runs the given query against Solr server.
- `drush search-api-pantheon:force-cleanup` (`sapfc`): Deletes all contents for the given Solr server.

## Solr Jargon

| Term       | Definition                                                                         |
| ---------- | ---------------------------------------------------------------------------------- |
| Commit     | To make document changes permanent in the index.                                   |
| Core       | An instance of the Solr server suitable for creating zero or more indices.         |
| Collection | Solr Cloud's version of a "CORE". Not currently used at Pantheon.                  |
| Document   | A group of fields and their values. The basic unit of data in a collection.        |
| Facet      | The arrangement of search results into categories based on indexed terms.          |
| Field      | The content to be indexed/searched along with metadata.                            |
| Index      | A group of metadata entries gathered by Solr into a searchable catalog.            |
| Schema     | A series of plain text and XML files that describe the data Solr will be indexing. |

## Feedback and Collaboration

Bug reports, feature requests, and feedback should be posted in [the drupal.org issue queue.](https://www.drupal.org/project/issues/search_api_pantheon?categories=All) For code changes, please submit pull requests against the [GitHub repository](https://github.com/pantheon-systems/search_api_pantheon).
