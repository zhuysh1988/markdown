Export resources so they can be used elsewhere 

The export command makes it easy to take existing objects and convert them to configuration files for backups or for creating elsewhere in the cluster. Fields that cannot be specified on create will be set to empty, and any field which is assigned on creation (like a service's clusterIP, or a deployment config's latestVersion). The status part of objects is also cleared. 

Some fields like clusterIP may be useful when exporting an application from one cluster to apply to another - assuming another service on the destination cluster does not already use that IP. The --exact flag will instruct export to not clear fields that might be useful. You may also use --raw to get the exact values for an object - useful for converting a file on disk between API versions. 

Another use case for export is to create reusable templates for applications. Pass --as-template to generate the API structure for a template to which you can add parameters and object labels.

Usage:
  oc export RESOURCE/NAME ... [options]

Examples:
  # export the services and deployment configurations labeled name=test
  oc export svc,dc -l name=test
  
  # export all services to a template
  oc export service --as-template=test
  
  # export to JSON
  oc export service -o json

Options:
      --all=true: DEPRECATED: all is ignored, specifying a resource without a name selects all the instances of that resource
      --all-namespaces=false: If true, list the requested object(s) across all namespaces. Namespace in current context is ignored even if specified with --namespace.
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --as-template='': Output a Template object with specified name instead of a List or single object.
      --exact=false: If true, preserve fields that may be cluster specific, such as service clusterIPs or generated names
  -f, --filename=[]: Filename, directory, or URL to file for the resource to export.
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
      --raw=false: If true, do not alter the resources in any way after they are loaded.
  -l, --selector='': Selector (label query) to filter on
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

Use "oc options" for a list of global command-line options (applies to all commands).
