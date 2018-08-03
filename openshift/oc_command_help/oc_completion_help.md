This command prints shell code which must be evaluated to provide interactive completion of oc commands.

Usage:
  oc completion SHELL [options]

Examples:
  # Generate the oc completion code for bash
  oc completion bash > bash_completion.sh
  source bash_completion.sh
  
  # The above example depends on the bash-completion framework.
  # It must be sourced before sourcing the openshift cli completion,
  # i.e. on the Mac:
  
  brew install bash-completion
  source $(brew --prefix)/etc/bash_completion
  oc completion bash > bash_completion.sh
  source bash_completion.sh
  
  # In zsh*, the following will load openshift cli zsh completion:
  source <(oc completion zsh)
  
  * zsh completions are only supported in versions of zsh >= 5.2

Use "oc options" for a list of global command-line options (applies to all commands).
