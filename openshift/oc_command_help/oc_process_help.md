Process template into a list of resources specified in filename or stdin 

Templates allow parameterization of resources prior to being sent to the server for creation or update. Templates have "parameters", which may either be generated on creation or set by the user, as well as metadata describing the template. 

The output of the process command is always a list of one or more resources. You may pipe the output to the create command over STDIN (using the '-f -' option) or redirect it to a file. 

Process resolves the template on the server, but you may pass --local to parameterize the template locally. When running locally be aware that the version of your client tools will determine what template transformations are supported, rather than the server.

Usage:
  oc process (TEMPLATE | -f FILENAME) [-p=KEY=VALUE] [options]

Examples:
  # Convert template.json file into resource list and pass to create
  oc process -f template.json | oc create -f -
  
  # Process a file locally instead of contacting the server
  oc process -f template.json --local -o yaml
  
  # Process template while passing a user-defined label
  oc process -f template.json -l name=mytemplate
  
  # Convert stored template into resource list
  oc process foo
  
  # Convert stored template into resource list by setting/overriding parameter values
  oc process foo PARM1=VALUE1 PARM2=VALUE2
  
  # Convert template stored in different namespace into a resource list
  oc process openshift//foo
  
  # Convert template.json into resource list
  cat template.json | oc process -f -

Options:
  -f, --filename='': Filename or URL to file to read a template
      --ignore-unknown-parameters=false: If true, will not stop processing if a provided parameter does not exist in the template.
  -l, --labels='': Label to set in all resources for this template
      --local=false: If true process the template locally instead of contacting the server.
  -o, --output='json': Output format. One of: describe|json|yaml|name|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
      --output-version='': Output the formatted object with the given version (default api-version).
  -p, --param=[]: Specify a key-value pair (eg. -p FOO=BAR) to set/override a parameter value in the template.
      --param-file=[]: File containing template parameter values to set/override in the template.
      --parameters=false: If true, do not process but only print available parameters
      --raw=false: If true, output the processed template instead of the template's objects. Implied by -o describe
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
  -t, --template='': Template string or path to template file to use when -o=go-template, -o=go-templatefile.  The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview]

Use "oc options" for a list of global command-line options (applies to all commands).
