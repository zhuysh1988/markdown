Autoscale a deployment config or replication controller. 

Looks up a deployment config or replication controller by name and creates an autoscaler that uses this deployment config or replication controller as a reference. An autoscaler can automatically increase or decrease number of pods deployed within the system as needed.

Usage:
  oc autoscale (-f FILENAME | TYPE NAME | TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [flags] [options]

Examples:
  # Auto scale a deployment config "foo", with the number of pods between 2 to
  # 10, target CPU utilization at a default value that server applies:
  oc autoscale dc/foo --min=2 --max=10
  
  # Auto scale a replication controller "foo", with the number of pods between
  # 1 to 5, target CPU utilization at 80%
  oc autoscale rc/foo --max=5 --cpu-percent=80

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --cpu-percent=-1: The target average CPU utilization (represented as a percent of requested CPU) over all the pods. If it's not specified or negative, a default autoscaling policy will be used.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to autoscale.
      --generator='horizontalpodautoscaler/v1': The name of the API generator to use. Currently there is only 1 generator.
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --max=-1: The upper limit for the number of pods that can be set by the autoscaler. Required.
      --min=-1: The lower limit for the number of pods that can be set by the autoscaler. If it's not specified or negative, the server will apply a default value.
      --name='': The name for the newly created object. If not specified, the name of the input resource will be used.
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
      --save-config=false: If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

Use "oc options" for a list of global command-line options (applies to all commands).
