Manage secrets in your project 

Secrets are used to store confidential information that should not be contained inside of an image. They are commonly used to hold things like keys for authentication to other internal systems like Docker registries.

Aliases:
secrets, secret

Usage:
  oc secrets [options]

Available Commands:
  add           DEPRECATED: secrets link
  link          Link secrets to a ServiceAccount
  new           DEPRECATED: create secret
  new-basicauth DEPRECATED: create secret
  new-dockercfg DEPRECATED: create secret
  new-sshauth   DEPRECATED: create secret
  unlink        Detach secrets from a ServiceAccount

Use "oc <command> --help" for more information about a given command.
Use "oc options" for a list of global command-line options (applies to all commands).
