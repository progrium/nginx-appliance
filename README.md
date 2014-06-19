# Nginx Appliance

A generic Nginx Docker container that you can configure at runtime via HTTP API. It was built using [Configurator](https://github.com/progrium/configurator), which means soon it will also integrate with various configuration stores (Consul, Etcd, ...).

It also means you can make a programmable appliance like this for any open source utility... but let's focus on Nginx for now.

## Getting the container

The container is available on the Docker Index:

	$ docker pull progrium/nginx

## Using the container

#### Getting the welcome page

	$ docker run -d -p 8000:80 progrium/nginx
	$ curl localhost:8000

Okay, that's maybe a little too trivial. The default Nginx config, big deal.

#### Configure Nginx into a reverse proxy

You've done this before. But have you done it like this?

	$ docker run -d -p 8000:80 -p 9000:9000 progrium/nginx

Add an upstream called `app` that points to `tired.com:80`:

	$ curl -d '{"upstream": {"app": {"server": {"tired.com:80": null}}}}' localhost:9000/v1/config/http

Turn the default server into a proxy to `app`:

	$ curl -d '{"server": [{"listen": 80, "location": {"/": {"proxy_pass": "http://app"}}}]}' localhost:9000/v1/config/http

*Now* hit that port 8000:

	$ curl localhost:8000

You re-programmed the Nginx appliance with curl.

#### Configure Nginx to serve your static files

Run with a volume mount to a location like `/static`:

	$ docker run -d -p 8000:80 -p 9000:9000 -v /your/files:/static progrium/nginx

Reconfigure the default server to use `/static` as the root and turn on autoindex:

	$ curl -d '{"root": "/static", "autoindex": true}' localhost:9000/v1/config/http/server/0

See your files:

	$ curl localhost:8000/

#### Working with the Nginx configuration

See the current configuration:

	$ docker run -d -p 8000:80 -p 9000:9000 progrium/nginx
	$ curl localhost:9000/v1/config/

See a subset or specific value of that Nginx configuration:
	
	$ curl localhost:9000/v1/config/http/server_names_hash_bucket_size

Change that value:

	$ curl -d '{"server_names_hash_bucket_size": 128}' localhost:9000/v1/config/http

See the full REST API and experiment...

#### See the actual rendered Nginx configuration being used

	$ curl localhost:/v1/render

#### Hook up your Nginx appliance to a configuration store

Coming soon. Pull your custom config from Consul, have your HTTP changes stored there, and...

#### Use configuration macros to pull more data from your config store

Coming soon. Make your configuration dynamic with macros that reference config store values:

	{
		...
		"http": {
			"server_names_hash_bucket_size": {"$value": "/consul/path/to/value"}
			...
		}
		...
	}

Values are watched and cause the Nginx configuration to change in real-time.

#### Iteration and conditionals with macros

Coming soon. The embedded macro language supports all your standard templating functionality.

#### AND MORE...

Get the idea?

## Sponsor

This project was made possible thanks to [DigitalOcean](http://digitalocean.com).

## License

BSD