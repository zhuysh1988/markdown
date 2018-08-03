Log in to your server and save login for subsequent use 

First-time users of the client should run this command to connect to a server, establish an authenticated session, and save connection to the configuration file. The default configuration will be saved to your home directory under ".kube/config". 

The information required to login -- like username and password, a session token, or the server details -- can be provided through flags. If not provided, the command will prompt for user input as needed.

Usage:
  oc login [URL] [options]

Examples:
  # Log in interactively
  oc login
  
  # Log in to the given server with the given certificate authority file
  oc login localhost:8443 --certificate-authority=/path/to/cert.crt
  
  # Log in to the given server with the given credentials (will not prompt interactively)
  oc login localhost:8443 --username=myuser --password=mypass

Options:
  -p, --password='': Password, will prompt if not provided
  -u, --username='': Username, will prompt if not provided      --certificate-authority='': Path to a cert file for the certificate authority
      --insecure-skip-tls-verify=false: If true, the server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --token='': Bearer token for authentication to the API server

Use "oc options" for a list of global command-line options (applies to all commands).
