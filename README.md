# README

## Setup

These instructions are meant for use on macOS.

To begin you can setup the MySQL database the application will be using. An easy way to do this is to first install Homebrew (see: [http://brew.sh/](http://brew.sh/)). Using the brew command you can install and start a basic MySQL server:

```
brew install mysql
mysql.server start
```

If you do not have Ruby 2.2.3 installed on your system, you can install the RVM tool (see: [https://rvm.io/](https://rvm.io/)). Once installed, you can install the correct Ruby version and switch to it with the following commands:

```
rvm install 2.2.3
rvm use 2.2.3
```

Next, use your terminal to navigate to the directory you wish to store this project, then clone it using git:

```
git clone ...
cd ...
```

Once you're in the project directory, you can install the required gems using bundler:

```
bundle install
```

After that, setup your MySQL databases by running:

```
rails db:setup
```

Finally, to verify your install is working properly, run the test suite with:

```
rails test
```

## Use Cases

The following use cases use the "curl" command to make JSON requests to the application running on your local system. Examples of the response to expect in JSON format will follow each use case.

To start up the application, run:

```
rails server
```

Take note, when specifying an Organization in the URL path for the following examples, the application expects the Organization's name, per the instructions for this project. Since the name is part of the URL's path, the name will need to be URL encoded properly. The following examples show the use of "%20" in place of spaces in an Organization's name.

### Create a new Organization

```
curl -X POST -H "Accept: application/json" -H "Content-Type:application/json" -d '{"organization": {"name": "My Organization"}}' http://localhost:3000/organizations
```

Example Response:

```json
{"name":"My Organization"}
```

### List all Organizations

```
curl -H "Accept: application/json" http://localhost:3000/organizations
```

Example Response:

```json
[
  {
    "name": "Test Org 0"
  },
  {
    "name": "Test Org 1"
  },
  {
    "name": "Test Org 2"
  },
  {
    "name": "Test Org 3"
  },
  {
    "name": "Test Org 4"
  },
  {
    "name": "Test Org 5"
  },
  {
    "name": "Test Org 6"
  },
  {
    "name": "Test Org 7"
  },
  {
    "name": "Test Org 8"
  },
  {
    "name": "Test Org 9"
  },
  {
    "name": "My Organization"
  }
]
```

### Delete an Organization

```
curl -X DELETE -H "Accept: application/json" http://localhost:3000/organizations/My%20Organization
```

### Create a new Event

```
curl -X POST -H "Accept: application/json" -H "Content-Type:application/json" -d '{"event": {"hostname": "my-organization.org", "message": "Hello World", "timestamp": "2017-01-22 23:46:18"}}' http://localhost:3000/organizations/Test%20Org%209/events
```

Example Response:

```json
{
  "id": 501,
  "message": "Hello World",
  "hostname": "my-organization.org",
  "timestamp": "2017-01-22 23:46:18"
}
```

### List all Events for all Organizations

```
curl -H "Accept: application/json" http://localhost:3000/events
```

Example Response:

(results cut short for display purposes)

```json
[
  {
    "id": 256,
    "message": "Test event 5 for Test Org 5",
    "hostname": "org-5-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 257,
    "message": "Test event 6 for Test Org 5",
    "hostname": "org-5-host-1.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 258,
    "message": "Test event 7 for Test Org 5",
    "hostname": "org-5-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  }
]
```

### List all Events for an Organization

```
curl -H "Accept: application/json" http://localhost:3000/organizations/Test%20Org%209/events
```

Example Response:

(results cut short for display purposes)

```json
[
  {
    "id": 451,
    "message": "Test event 0 for Test Org 9",
    "hostname": "org-9-host-1.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 452,
    "message": "Test event 1 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 453,
    "message": "Test event 2 for Test Org 9",
    "hostname": "org-9-host-1.com",
    "timestamp": "2017-01-23 08:16:02"
  }
]
```

### List the last N Events for an Organization

```
curl -H "Accept: application/json" http://localhost:3000/organizations/Test%20Org%209/events?limit=5
```

Example Response:

```json
[
  {
    "id": 500,
    "message": "Test event 49 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 499,
    "message": "Test event 48 for Test Org 9",
    "hostname": "org-9-host-1.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 498,
    "message": "Test event 47 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 497,
    "message": "Test event 46 for Test Org 9",
    "hostname": "org-9-host-1.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 496,
    "message": "Test event 45 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  }
]
```

### List the last N Events for a specific Hostname within a specific Organization

```
curl -H "Accept: application/json" http://localhost:3000/organizations/Test%20Org%209/events?limit=5&hostname=org-9-host-2.com
```

Example Response:

```json
[
  {
    "id": 452,
    "message": "Test event 1 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 454,
    "message": "Test event 3 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 456,
    "message": "Test event 5 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 458,
    "message": "Test event 7 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  },
  {
    "id": 460,
    "message": "Test event 9 for Test Org 9",
    "hostname": "org-9-host-2.com",
    "timestamp": "2017-01-23 08:16:02"
  }
]
```
