Create a new project for yourself 

If your administrator allows self-service, this command will create a new project for you and assign you as the project admin. 

After your project is created it will become the default project in your config.

Usage:
  oc new-project NAME [--display-name=DISPLAYNAME] [--description=DESCRIPTION] [options]

Examples:
  # Create a new project with minimal information
  oc new-project web-team-dev
  
  # Create a new project with a display name and description
  oc new-project web-team-dev --display-name="Web Team Development" --description="Development project for the web team."

Options:
      --description='': Project description
      --display-name='': Project display name
      --skip-config-write=false: If true, the project will not be set as a cluster entry in kubeconfig after being created

Use "oc options" for a list of global command-line options (applies to all commands).
