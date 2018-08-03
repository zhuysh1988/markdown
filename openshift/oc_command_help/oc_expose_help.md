Expose containers internally as services or externally via routes 

There is also the ability to expose a deployment configuration, replication controller, service, or pod as a new service on a specified port. If no labels are specified, the new object will re-use the labels from the object it exposes.

Usage:
  oc expose (-f FILENAME | TYPE NAME) [--port=port] [--protocol=TCP|UDP] [--target-port=number-or-name] [--name=name] [--external-ip=external-ip-of-service] [--type=type] [options]

Examples:
  # Create a route based on service nginx. The new route will re-use nginx's labels
  oc expose service nginx
  
  # Create a route and specify your own label and route name
  oc expose service nginx -l name=myroute --name=fromdowntown
  
  # Create a route and specify a hostname
  oc expose service nginx --hostname=www.example.com
  
  # Create a route with wildcard
  oc expose service nginx --hostname=x.example.com --wildcard-policy=Subdomain
  This would be equivalent to *.example.com. NOTE: only hosts are matched by the wildcard, subdomains would not be included.
  
  # Expose a deployment configuration as a service and use the specified port
  oc expose dc ruby-hello-world --port=8080
  
  # Expose a service as a route in the specified path
  oc expose service nginx --path=/nginx
  
  # Expose a service using different generators
  oc expose service nginx --name=exposed-svc --port=12201 --protocol="TCP" --generator="service/v2"
  oc expose service nginx --name=my-route --port=12201 --generator="route/v1"
  
  Exposing a service using the "route/v1" generator (default) will create a new exposed route with the "--name" provided
  (or the name of the service otherwise). You may not specify a "--protocol" or "--target-port" option when using this generator.

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --cluster-ip='': ClusterIP to be assigned to the service. Leave empty to auto-allocate, or set to 'None' to create a headless service.
      --container-port='': Synonym for --target-port
      --dry-run=false: If true, only print the object that would be sent, without sending it.
      --external-ip='': Additional external IP address (not managed by Kubernetes) to accept for the service. If this IP is routed to a node, the service can be accessed by this IP in addition to its generated service IP.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to expose a service
      --generator='': The name of the API generator to use. Defaults to "route/v1". Available generators include "service/v1", "service/v2", and "route/v1". "service/v1" will automatically name the port "default", while "service/v2" will leave it unnamed.
      --hostname='': Set a hostname for the new route
  -l, --labels='': Labels to apply to the service created by this call.
      --load-balancer-ip='': IP to assign to the Load Balancer. If empty, an ephemeral IP will be created and used (cloud-provider specific).
      --name='': The name for the newly created object.
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
      --overrides='': An inline JSON override for the generated object. If this is non-empty, it is used to override the generated object. Requires that the object supply a valid apiVersion field.
      --path='': Set a path for the new route
      --port='': The port that the resource should serve on.
      --protocol='': The network protocol for the service to be created. Default is 'TCP'.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
      --selector='': A label selector to use for this service. Only equality-based selector requirements are supported. If empty (the default) infer the selector from the replication controller or replica set.)
      --session-affinity='': If non-empty, set the session affinity for the service to this; legal values: 'None', 'ClientIP'
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --target-port='': Name or number for the port on the container that the service should direct traffic to. Optional.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --type='': Type for this service: ClusterIP, NodePort, LoadBalancer, or ExternalName. Default is 'ClusterIP'.
      --wildcard-policy='': Sets the WildcardPolicy for the hostname, the default is "None". Valid values are "None" and "Subdomain"

Use "oc options" for a list of global command-line options (applies to all commands).
