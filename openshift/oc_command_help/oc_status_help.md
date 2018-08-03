Show a high level overview of the current project 

This command will show services, deployment configs, build configurations, and active deployments. If you have any misconfigured components information about them will be shown. For more information about individual items, use the describe command (e.g. oc describe buildConfig, oc describe deploymentConfig, oc describe service). 

You can specify an output format of "-o dot" to have this command output the generated status graph in DOT format that is suitable for use by the "dot" command.

Usage:
  oc status [-o dot | -v ] [options]

Examples:
  # See an overview of the current project.
  oc status
  
  # Export the overview of the current project in an svg file.
  oc status -o dot | dot -T svg -o project.svg
  
  # See an overview of the current project including details for any identified issues.
  oc status -v

Options:
      --all-namespaces=false: If true, display status for all namespaces (must have cluster admin)
  -o, --output='': Output format. One of: dot.
  -v, --verbose=false: See details for resolving issues.

Use "oc options" for a list of global command-line options (applies to all commands).
