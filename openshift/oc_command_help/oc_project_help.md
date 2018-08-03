Switch to another project and make it the default in your configuration 

If no project was specified on the command line, display information about the current active project. Since you can use this command to connect to projects on different servers, you will occasionally encounter projects of the same name on different servers. When switching to that project, a new local context will be created that will have a unique name - for instance, 'myapp-2'. If you have previously created a context with a different name than the project name, this command will accept that context name instead. 

For advanced configuration, or to manage the contents of your config file, use the 'config' command.

Usage:
  oc project [NAME] [options]

Examples:
  # Switch to 'myapp' project
  oc project myapp
  
  # Display the project currently in use
  oc project

Options:
  -q, --short=false: If true, display only the project name

Use "oc options" for a list of global command-line options (applies to all commands).
