Update the annotations on one or more resources 

An annotation is a key/value pair that can hold larger (compared to a label), and possibly not human-readable, data. It is intended to store non-identifying auxiliary data, especially data manipulated by tools and system extensions. If --overwrite is true, then existing annotations can be overwritten, otherwise attempting to overwrite an annotation will result in an error. If --resource-version is specified, then updates will use this resource version, otherwise the existing resource-version will be used. 

Run 'oc types' for a list of valid resources.

Usage:
  oc annotate [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version] [options]

Examples:
  # Update pod 'foo' with the annotation 'description' and the value 'my frontend'.
  # If the same annotation is set multiple times, only the last value will be applied
  oc annotate pods foo description='my frontend'
  
  # Update pod 'foo' with the annotation 'description' and the value
  # 'my frontend running nginx', overwriting any existing value.
  oc annotate --overwrite pods foo description='my frontend running nginx'
  
  # Update all pods in the namespace
  oc annotate pods --all description='my frontend running nginx'
  
  # Update pod 'foo' only if the resource is unchanged from version 1.
  oc annotate pods foo description='my frontend running nginx' --resource-version=1
  
  # Update pod 'foo' by removing an annotation named 'description' if it exists.
  # Does not require the --overwrite flag.
  oc annotate pods foo description-

Options:
      --all=false: Select all resources, including uninitialized ones, in the namespace of the specified resource types.
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --dry-run=false: If true, only print the object that would be sent, without sending it.
  -f, --filename=[]: Filename, directory, or URL to files identifying the resource to update the annotation
      --include-extended-apis=true: If true, include definitions of new APIs via calls to the API server. [default true]
      --include-uninitialized=false: If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all". Objects with empty metadata.initializers are regarded as initialized.
      --local=false: If true, annotation will NOT contact api-server but run locally.
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
      --overwrite=false: If true, allow annotations to be overwritten, otherwise reject annotation updates that overwrite existing annotations.
      --record=false: Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.
  -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.
      --resource-version='': If non-empty, the annotation update will only succeed if this is the current resource-version for the object. Only valid when specifying a single resource.
  -l, --selector='': Selector (label query) to filter on, not including uninitialized ones, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2).
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

Use "oc options" for a list of global command-line options (applies to all commands).
