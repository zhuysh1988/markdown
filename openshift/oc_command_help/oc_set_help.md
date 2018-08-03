Configure application resources 

These commands help you make changes to existing application resources.

Usage:
  oc set COMMAND [options]

Replication controllers, deployments, and daemon sets:
  env             Update environment variables on a pod template
  resources       Update resource requests/limits on objects with pod templates
  volumes         Update volumes on a pod template
  probe           Update a probe on a pod template
  deployment-hook Update a deployment hook on a deployment config
  image           Update image of a pod template

Manage secrets:
  build-secret    Update a build secret on a build config

Manage application flows:
  image-lookup    Change how images are resolved when deploying applications
  triggers        Update the triggers on one or more objects
  build-hook      Update a build hook on a build config

Control load balancing:
  route-backends  Update the backends for a route

Use "oc set <command> --help" for more information about a given command.
Use "oc options" for a list of global command-line options (applies to all commands).
