Show information about the current session 

The default options for this command will return the currently authenticated user name or an empty string.  Other flags support returning the currently used token or the user context.

Usage:
  oc whoami [options]

Options:
  -c, --show-context=false: Print the current user context name
      --show-server=false: If true, print the current server's REST API URL
  -t, --show-token=false: Print the token the current session is using. This will return an error if you are using a different form of authentication.

Use "oc options" for a list of global command-line options (applies to all commands).
