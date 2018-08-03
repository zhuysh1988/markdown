Running Apache as a Service

Apache comes with a utility called the Apache Service Monitor. With it you can see and manage the state of all installed Apache services on any machine on your network. To be able to manage an Apache service with the monitor, you have to first install the service (either automatically via the installation or manually).

You can install Apache as a Windows NT service as follows from the command prompt at the Apache bin subdirectory:

httpd.exe -k install
If you need to specify the name of the service you want to install, use the following command. You have to do this if you have several different service installations of Apache on your computer. If you specify a name during the install, you have to also specify it during any other -k operation.

httpd.exe -k install -n "MyServiceName"
If you need to have specifically named configuration files for different services, you must use this:

httpd.exe -k install -n "MyServiceName" -f "c:\files\my.conf"
If you use the first command without any special parameters except -k install, the service will be called Apache2.4 and the configuration will be assumed to be conf\httpd.conf.

Removing an Apache service is easy. Just use:

httpd.exe -k uninstall
The specific Apache service to be uninstalled can be specified by using:

httpd.exe -k uninstall -n "MyServiceName"
Normal starting, restarting and shutting down of an Apache service is usually done via the Apache Service Monitor, by using commands like NET START Apache2.4 and NET STOP Apache2.4 or via normal Windows service management. Before starting Apache as a service by any means, you should test the service's configuration file by using:

httpd.exe -n "MyServiceName" -t
You can control an Apache service by its command line switches, too. To start an installed Apache service you'll use this:

httpd.exe -k start -n "MyServiceName"
To stop an Apache service via the command line switches, use this:

httpd.exe -k stop -n "MyServiceName"
or

httpd.exe -k shutdown -n "MyServiceName"
You can also restart a running service and force it to reread its configuration file by using:

httpd.exe -k restart -n "MyServiceName"
By default, all Apache services are registered to run as the system user (the LocalSystem account). The LocalSystem account has no privileges to your network via any Windows-secured mechanism, including the file system, named pipes, DCOM, or secure RPC. It has, however, wide privileges locally.

Never grant any network privileges to the LocalSystem account! If you need Apache to be able to access network resources, create a separate account for Apache as noted below.
It is recommended that users create a separate account for running Apache service(s). If you have to access network resources via Apache, this is required.

Create a normal domain user account, and be sure to memorize its password.
Grant the newly-created user a privilege of Log on as a service and Act as part of the operating system. On Windows NT 4.0 these privileges are granted via User Manager for Domains, but on Windows 2000 and XP you probably want to use Group Policy for propagating these settings. You can also manually set these via the Local Security Policy MMC snap-in.
Confirm that the created account is a member of the Users group.
Grant the account read and execute (RX) rights to all document and script folders (htdocs and cgi-bin for example).
Grant the account change (RWXD) rights to the Apache logs directory.
Grant the account read and execute (RX) rights to the httpd.exe binary executable.
It is usually a good practice to grant the user the Apache service runs as read and execute (RX) access to the whole Apache2.4 directory, except the logs subdirectory, where the user has to have at least change (RWXD) rights.
If you allow the account to log in as a user and as a service, then you can log on with that account and test that the account has the privileges to execute the scripts, read the web pages, and that you can start Apache in a console window. If this works, and you have followed the steps above, Apache should execute as a service with no problems.

Error code 2186 is a good indication that you need to review the "Log On As" configuration for the service, since Apache cannot access a required network resource. Also, pay close attention to the privileges of the user Apache is configured to run as.
When starting Apache as a service you may encounter an error message from the Windows Service Control Manager. For example, if you try to start Apache by using the Services applet in the Windows Control Panel, you may get the following message:

Could not start the Apache2.4 service on \\COMPUTER 
Error 1067; The process terminated unexpectedly.
You will get this generic error if there is any problem with starting the Apache service. In order to see what is really causing the problem you should follow the instructions for Running Apache for Windows from the Command Prompt.

If you are having problems with the service, it is suggested you follow the instructions below to try starting httpd.exe from a console window, and work out the errors before struggling to start it as a service again.

top
Running Apache as a Console Application

Running Apache as a service is usually the recommended way to use it, but it is sometimes easier to work from the command line, especially during initial configuration and testing.

To run Apache from the command line as a console application, use the following command:

httpd.exe
Apache will execute, and will remain running until it is stopped by pressing Control-C.

You can also run Apache via the shortcut Start Apache in Console placed to Start Menu --> Programs --> Apache HTTP Server 2.4.xx --> Control Apache Server during the installation. This will open a console window and start Apache inside it. If you don't have Apache installed as a service, the window will remain visible until you stop Apache by pressing Control-C in the console window where Apache is running in. The server will exit in a few seconds. However, if you do have Apache installed as a service, the shortcut starts the service. If the Apache service is running already, the shortcut doesn't do anything.

If Apache is running as a service, you can tell it to stop by opening another console window and entering:

httpd.exe -k shutdown
Running as a service should be preferred over running in a console window because this lets Apache end any current operations and clean up gracefully.

But if the server is running in a console window, you can only stop it by pressing Control-C in the same window.

You can also tell Apache to restart. This forces it to reread the configuration file. Any operations in progress are allowed to complete without interruption. To restart Apache, either press Control-Break in the console window you used for starting Apache, or enter

httpd.exe -k restart
if the server is running as a service.

Note for people familiar with the Unix version of Apache: these commands provide a Windows equivalent to kill -TERM pid and kill -USR1 pid. The command line option used, -k, was chosen as a reminder of the kill command used on Unix.
If the Apache console window closes immediately or unexpectedly after startup, open the Command Prompt from the Start Menu --> Programs. Change to the folder to which you installed Apache, type the command httpd.exe, and read the error message. Then change to the logs folder, and review the error.log file for configuration mistakes. Assuming httpd was installed into C:\Program Files\Apache Software Foundation\Apache2.4\, you can do the following:

c: 
cd "\Program Files\Apache Software Foundation\Apache2.4\bin" 
httpd.exe
Then wait for Apache to stop, or press Control-C. Then enter the following:

cd ..\logs 
more < error.log
When working with Apache it is important to know how it will find the configuration file. You can specify a configuration file on the command line in two ways:

-f specifies an absolute or relative path to a particular configuration file:

httpd.exe -f "c:\my server files\anotherconfig.conf"
or

httpd.exe -f files\anotherconfig.conf
-n specifies the installed Apache service whose configuration file is to be used:

httpd.exe -n "MyServiceName"
In both of these cases, the proper ServerRoot should be set in the configuration file.

If you don't specify a configuration file with -f or -n, Apache will use the file name compiled into the server, such as conf\httpd.conf. This built-in path is relative to the installation directory. You can verify the compiled file name from a value labelled as SERVER_CONFIG_FILE when invoking Apache with the -V switch, like this:

httpd.exe -V
Apache will then try to determine its ServerRoot by trying the following, in this order:

A ServerRoot directive via the -C command line switch.
The -d switch on the command line.
Current working directory.
A registry entry which was created if you did a binary installation.
The server root compiled into the server. This is /apache by default, you can verify it by using httpd.exe -V and looking for a value labelled as HTTPD_ROOT.
If you did not do a binary install, Apache will in some scenarios complain about the missing registry key. This warning can be ignored if the server was otherwise able to find its configuration file.

The value of this key is the ServerRoot directory which contains the conf subdirectory. When Apache starts it reads the httpd.conf file from that directory. If this file contains a ServerRoot directive which contains a different directory from the one obtained from the registry key above, Apache will forget the registry key and use the directory from the configuration file. If you copy the Apache directory or configuration files to a new location it is vital that you update the ServerRoot directive in the httpd.conf file to reflect the new location.

top
Testing the Installation

After starting Apache (either in a console window or as a service) it will be listening on port 80 (unless you changed the Listen directive in the configuration files or installed Apache only for the current user). To connect to the server and access the default page, launch a browser and enter this URL:

http://localhost/
Apache should respond with a welcome page and you should see "It Works!". If nothing happens or you get an error, look in the error.log file in the logs subdirectory. If your host is not connected to the net, or if you have serious problems with your DNS (Domain Name Service) configuration, you may have to use this URL:

http://127.0.0.1/
If you happen to be running Apache on an alternate port, you need to explicitly put that in the URL:

http://127.0.0.1:8080/
Once your basic installation is working, you should configure it properly by editing the files in the conf subdirectory. Again, if you change the configuration of the Windows NT service for Apache, first attempt to start it from the command line to make sure that the service starts with no errors.

Because Apache cannot share the same port with another TCP/IP application, you may need to stop, uninstall or reconfigure certain other services before running Apache. These conflicting services include other WWW servers, some firewall implementations, and even some client applications (such as Skype) which will use port 80 to attempt to bypass firewall issues.

top
Configuring Access to Network Resources

Access to files over the network can be specified using two mechanisms provided by Windows:

Mapped drive letters
e.g., Alias "/images/" "Z:/"
UNC paths
e.g., Alias "/images/" "//imagehost/www/images/"
Mapped drive letters allow the administrator to maintain the mapping to a specific machine and path outside of the Apache httpd configuration. However, these mappings are associated only with interactive sessions and are not directly available to Apache httpd when it is started as a service. Use only UNC paths for network resources in httpd.conf so that the resources can be accessed consistently regardless of how Apache httpd is started. (Arcane and error prone procedures may work around the restriction on mapped drive letters, but this is not recommended.)

Example DocumentRoot with UNC path

DocumentRoot "//dochost/www/html/"
Example DocumentRoot with IP address in UNC path

DocumentRoot "//192.168.1.50/docs/"
Example Alias and corresponding Directory with UNC path

Alias "/images/" "//imagehost/www/images/"

<Directory "//imagehost/www/images/">
#...
<Directory>
When running Apache httpd as a service, you must create a separate account in order to access network resources, as described abov