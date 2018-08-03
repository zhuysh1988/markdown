Revert an application back to a previous deployment 

When you run this command your deployment configuration will be updated to match a previous deployment. By default only the pod and container configuration will be changed and scaling or trigger settings will be left as- is. Note that environment variables and volumes are included in rollbacks, so if you've recently updated security credentials in your environment your previous deployment may not have the correct values. 

Any image triggers present in the rolled back configuration will be disabled with a warning. This is to help prevent your rolled back deployment from being replaced by a triggered deployment soon after your rollback. To re-enable the triggers, use the 'deploy' command. 

If you would like to review the outcome of the rollback, pass '--dry-run' to print a human-readable representation of the updated deployment configuration instead of executing the rollback. This is useful if you're not quite sure what the outcome will be.

Usage:
  oc rollback (DEPLOYMENTCONFIG | DEPLOYMENT) [options]

Examples:
  # Perform a rollback to the last successfully completed deployment for a deploymentconfig
  oc rollback frontend
  
  # See what a rollback to version 3 will look like, but don't perform the rollback
  oc rollback frontend --to-version=3 --dry-run
  
  # Perform a rollback to a specific deployment
  oc rollback frontend-2
  
  # Perform the rollback manually by piping the JSON of the new config back to oc
  oc rollback frontend -o json | oc replace dc/frontend -f -
  
  # Print the updated deployment configuration in JSON format instead of performing the rollback
  oc rollback frontend -o json

Options:
      --allow-missing-template-keys=true: If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
      --change-scaling-settings=false: If true, include the previous deployment's replicationController replica count and selector in the rollback
      --change-strategy=false: If true, include the previous deployment's strategy in the rollback
      --change-triggers=false: If true, include the previous deployment's triggers in the rollback
  -d, --dry-run=false: Instead of performing the rollback, describe what the rollback will look like in human-readable form
      --no-headers=false: When using the default or custom-column output format, don't print headers (default print headers).
  -o, --output='': Output format. One of: json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See custom columns [http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns], golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://kubernetes.io/docs/user-guide/jsonpath].
  -a, --show-all=true: When printing, show all resources (false means hide terminated pods.)
      --show-labels=false: When printing, show all labels as the last column (default hide labels column)
      --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
      --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
      --to-version=0: A config version to rollback to. Specifying version 0 is the same as omitting a version (the version will be auto-detected). This option is ignored when specifying a deployment.

Use "oc options" for a list of global command-line options (applies to all commands).
