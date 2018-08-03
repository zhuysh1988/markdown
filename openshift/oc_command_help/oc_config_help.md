Manage the client config files 

The client stores configuration in the current user's home directory (under the .kube directory as config). When you login the first time, a new config file is created, and subsequent project changes with the 'project' command will set the current context. These subcommands allow you to manage the config directly. 

Reference: https://github.com/kubernetes/kubernetes/blob/master/docs/user-guide/kubeconfig-file.md

Usage:
  oc config SUBCOMMAND [options]

Examples:
  # Change the config context to use
  oc config use-context my-context
  
  # Set the value of a config preference
  oc config set preferences.some true

Available Commands:
  current-context Displays the current-context
  delete-cluster  Delete the specified cluster from the kubeconfig
  delete-context  Delete the specified context from the kubeconfig
  get-clusters    Display clusters defined in the kubeconfig
  get-contexts    Describe one or many contexts
  rename-context  Renames a context from the kubeconfig file.
  set             Sets an individual value in a kubeconfig file
  set-cluster     Sets a cluster entry in kubeconfig
  set-context     Sets a context entry in kubeconfig
  set-credentials Sets a user entry in kubeconfig
  unset           Unsets an individual value in a kubeconfig file
  use-context     Sets the current-context in a kubeconfig file
  view            Display merged kubeconfig settings or a specified kubeconfig file

Use "oc <command> --help" for more information about a given command.
Use "oc options" for a list of global command-line options (applies to all commands).
