Administrative Commands 

Commands for managing a cluster are exposed here. Many administrative actions involve interaction with the command-line client as well.

Component Installation:
  router                             Install a router
  ipfailover                         Install an IP failover group to a set of nodes
  registry                           Install the integrated Docker registry

Security and Policy:
  new-project                        Create a new project
  policy                             Manage policy
  groups                             Manage groups
  ca                                 Manage certificates and keys
  certificate                        Modify certificate resources.

Node Management:
  create-node-config                 Create a configuration bundle for a node
  manage-node                        Manage nodes - list pods, evacuate, or mark ready
  cordon                             Mark node as unschedulable
  uncordon                           Mark node as schedulable
  drain                              Drain node in preparation for maintenance
  taint                              Update the taints on one or more nodes
  pod-network                        Manage pod network

Maintenance:
  diagnostics                        Diagnose common cluster problems
  prune                              Remove older versions of resources from the server
  build-chain                        Output the inputs and dependencies of your builds
  migrate                            Migrate data in the cluster
  top                                Show usage statistics of resources on the server
  verify-image-signature             Verify the image identity contained in the image signature

Configuration:
  create-kubeconfig                  Create a basic .kubeconfig file from client certs
  create-api-client-config           Create a config file for connecting to the server as a user
  create-bootstrap-project-template  Create a bootstrap project template
  create-bootstrap-policy-file       Create the default bootstrap policy
  create-login-template              Create a login template
  create-provider-selection-template Create a provider selection template
  create-error-template              Create an error page template

Other Commands:
  completion                         Output shell completion code for the specified shell (bash or zsh)
  config                             Change configuration files for the client

Use "oc adm <command> --help" for more information about a given command.
Use "oc adm options" for a list of global command-line options (applies to all commands).
