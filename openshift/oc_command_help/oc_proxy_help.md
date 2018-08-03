Run a proxy to the API server

Usage:
  oc proxy [--port=PORT] [--www=static-dir] [--www-prefix=prefix] [--api-prefix=prefix] [options]

Examples:
  # Run a proxy to the api server on port 8011, serving static content from ./local/www/
  oc proxy --port=8011 --www=./local/www/
  
  # Run a proxy to the api server on an arbitrary local port.
  # The chosen port for the server will be output to stdout.
  oc proxy --port=0
  
  # Run a proxy to the api server, changing the api prefix to my-api
  # This makes e.g. the pods api available at localhost:8011/my-api/api/v1/pods/
  oc proxy --api-prefix=/my-api

Options:
      --accept-hosts='^localhost$,^127\.0\.0\.1$,^\[::1\]$': Regular expression for hosts that the proxy should accept.
      --accept-paths='^.*': Regular expression for paths that the proxy should accept.
      --address='127.0.0.1': The IP address on which to serve on.
      --api-prefix='/': Prefix to serve the proxied API under.
      --disable-filter=false: If true, disable request filtering in the proxy. This is dangerous, and can leave you vulnerable to XSRF attacks, when used with an accessible port.
  -p, --port=8001: The port on which to run the proxy. Set to 0 to pick a random port.
      --reject-methods='^$': Regular expression for HTTP methods that the proxy should reject (example --reject-methods='POST,PUT,PATCH'). 
      --reject-paths='^/api/.*/pods/.*/exec,^/api/.*/pods/.*/attach': Regular expression for paths that the proxy should reject. Paths specified here will be rejected even accepted by --accept-paths.
  -u, --unix-socket='': Unix socket on which to run the proxy.
  -w, --www='': Also serve static files from the given directory under the specified prefix.
  -P, --www-prefix='/static/': Prefix to serve static files under, if static file directory is specified.

Use "oc options" for a list of global command-line options (applies to all commands).
