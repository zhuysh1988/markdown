usage: openstack [--version] [-v | -q] [--log-file LOG_FILE] [-h] [--debug]
                 [--os-cloud <cloud-config-name>]
                 [--os-region-name <auth-region-name>]
                 [--os-cacert <ca-bundle-file>] [--os-cert <certificate-file>]
                 [--os-key <key-file>] [--verify | --insecure]
                 [--os-default-domain <auth-domain>]
                 [--os-interface <interface>]
                 [--os-service-provider <service_provider>]
                 [--os-remote-project-name <remote_project_name> | --os-remote-project-id <remote_project_id>]
                 [--os-remote-project-domain-name <remote_project_domain_name> | --os-remote-project-domain-id <remote_project_domain_id>]
                 [--timing] [--os-beta-command]
                 [--os-compute-api-version <compute-api-version>]
                 [--os-network-api-version <network-api-version>]
                 [--os-image-api-version <image-api-version>]
                 [--os-volume-api-version <volume-api-version>]
                 [--os-identity-api-version <identity-api-version>]
                 [--os-object-api-version <object-api-version>]
                 [--os-event-api-version <event-api-version>]
                 [--os-metrics-api-version <metrics-api-version>]
                 [--os-alarming-api-version <alarming-api-version>]
                 [--os-auth-type <auth-type>]
                 [--os-project-domain-id <auth-project-domain-id>]
                 [--os-protocol <auth-protocol>]
                 [--os-project-name <auth-project-name>]
                 [--os-trust-id <auth-trust-id>]
                 [--os-service-provider-endpoint <auth-service-provider-endpoint>]
                 [--os-domain-name <auth-domain-name>]
                 [--os-user-domain-id <auth-user-domain-id>]
                 [--os-access-token-type <auth-access-token-type>]
                 [--os-code <auth-code>]
                 [--os-identity-provider-url <auth-identity-provider-url>]
                 [--os-default-domain-name <auth-default-domain-name>]
                 [--os-access-token-endpoint <auth-access-token-endpoint>]
                 [--os-access-token <auth-access-token>]
                 [--os-domain-id <auth-domain-id>]
                 [--os-user-domain-name <auth-user-domain-name>]
                 [--os-openid-scope <auth-openid-scope>]
                 [--os-user-id <auth-user-id>]
                 [--os-identity-provider <auth-identity-provider>]
                 [--os-username <auth-username>]
                 [--os-auth-url <auth-auth-url>]
                 [--os-client-secret <auth-client-secret>]
                 [--os-default-domain-id <auth-default-domain-id>]
                 [--os-discovery-endpoint <auth-discovery-endpoint>]
                 [--os-client-id <auth-client-id>]
                 [--os-project-domain-name <auth-project-domain-name>]
                 [--os-service-provider-entity-id <auth-service-provider-entity-id>]
                 [--os-password <auth-password>]
                 [--os-redirect-uri <auth-redirect-uri>]
                 [--os-endpoint <auth-endpoint>]
                 [--os-aodh-endpoint <auth-aodh-endpoint>]
                 [--os-roles <auth-roles>] [--os-url <auth-url>]
                 [--os-token <auth-token>] [--os-passcode <auth-passcode>]
                 [--os-project-id <auth-project-id>] [--os-user <auth-user>]

Command-line interface to the OpenStack APIs

optional arguments:
  --version             show program's version number and exit
  -v, --verbose         Increase verbosity of output. Can be repeated.
  -q, --quiet           Suppress output except warnings and errors.
  --log-file LOG_FILE   Specify a file to log output. Disabled by default.
  -h, --help            Show help message and exit.
  --debug               Show tracebacks on errors.
  --os-cloud <cloud-config-name>
                        Cloud name in clouds.yaml (Env: OS_CLOUD)
  --os-region-name <auth-region-name>
                        Authentication region name (Env: OS_REGION_NAME)
  --os-cacert <ca-bundle-file>
                        CA certificate bundle file (Env: OS_CACERT)
  --os-cert <certificate-file>
                        Client certificate bundle file (Env: OS_CERT)
  --os-key <key-file>   Client certificate key file (Env: OS_KEY)
  --verify              Verify server certificate (default)
  --insecure            Disable server certificate verification
  --os-default-domain <auth-domain>
                        Default domain ID, default=default. (Env:
                        OS_DEFAULT_DOMAIN)
  --os-interface <interface>
                        Select an interface type. Valid interface types:
                        [admin, public, internal]. (Env: OS_INTERFACE)
  --os-service-provider <service_provider>
                        Authenticate with and perform the command on a service
                        provider using Keystone-to-keystone federation. Must
                        also specify the remote project option.
  --os-remote-project-name <remote_project_name>
                        Project name when authenticating to a service provider
                        if using Keystone-to-Keystone federation.
  --os-remote-project-id <remote_project_id>
                        Project ID when authenticating to a service provider
                        if using Keystone-to-Keystone federation.
  --os-remote-project-domain-name <remote_project_domain_name>
                        Domain name of the project when authenticating to a
                        service provider if using Keystone-to-Keystone
                        federation.
  --os-remote-project-domain-id <remote_project_domain_id>
                        Domain ID of the project when authenticating to a
                        service provider if using Keystone-to-Keystone
                        federation.
  --timing              Print API call timing info
  --os-beta-command     Enable beta commands which are subject to change
  --os-compute-api-version <compute-api-version>
                        Compute API version, default=2.1 (Env:
                        OS_COMPUTE_API_VERSION)
  --os-network-api-version <network-api-version>
                        Network API version, default=2.0 (Env:
                        OS_NETWORK_API_VERSION)
  --os-image-api-version <image-api-version>
                        Image API version, default=2 (Env:
                        OS_IMAGE_API_VERSION)
  --os-volume-api-version <volume-api-version>
                        Volume API version, default=2 (Env:
                        OS_VOLUME_API_VERSION)
  --os-identity-api-version <identity-api-version>
                        Identity API version, default=3 (Env:
                        OS_IDENTITY_API_VERSION)
  --os-object-api-version <object-api-version>
                        Object API version, default=1 (Env:
                        OS_OBJECT_API_VERSION)
  --os-event-api-version <event-api-version>
                        Event API version, default=2 (Env:
                        OS_EVENT_API_VERSION)
  --os-metrics-api-version <metrics-api-version>
                        Metrics API version, default=1 (Env:
                        OS_METRICS_API_VERSION)
  --os-alarming-api-version <alarming-api-version>
                        Queues API version, default=2 (Env:
                        OS_ALARMING_API_VERSION)
  --os-auth-type <auth-type>
                        Select an authentication type. Available types:
                        v2token, none, password, admin_token, v3oidcauthcode,
                        v2password, v3samlpassword, v3password,
                        v3adfspassword, v3oidcaccesstoken, token_endpoint,
                        token, v3oidcclientcredentials, noauth, v3token,
                        v3totp, v3tokenlessauth, gnocchi-noauth,
                        v3oidcpassword, aodh-noauth, gnocchi-basic. Default:
                        selected based on --os-username/--os-token (Env:
                        OS_AUTH_TYPE)
  --os-project-domain-id <auth-project-domain-id>
                        With password: Domain ID containing project With
                        v3oidcauthcode: Domain ID containing project With
                        v3samlpassword: Domain ID containing project With
                        v3password: Domain ID containing project With
                        v3adfspassword: Domain ID containing project With
                        v3oidcaccesstoken: Domain ID containing project With
                        token: Domain ID containing project With
                        v3oidcclientcredentials: Domain ID containing project
                        With v3token: Domain ID containing project With
                        v3totp: Domain ID containing project With
                        v3tokenlessauth: Domain ID containing project With
                        v3oidcpassword: Domain ID containing project (Env:
                        OS_PROJECT_DOMAIN_ID)
  --os-protocol <auth-protocol>
                        With v3oidcauthcode: Protocol for federated plugin
                        With v3samlpassword: Protocol for federated plugin
                        With v3adfspassword: Protocol for federated plugin
                        With v3oidcaccesstoken: Protocol for federated plugin
                        With v3oidcclientcredentials: Protocol for federated
                        plugin With v3oidcpassword: Protocol for federated
                        plugin (Env: OS_PROTOCOL)
  --os-project-name <auth-project-name>
                        With password: Project name to scope to With
                        v3oidcauthcode: Project name to scope to With
                        v3samlpassword: Project name to scope to With
                        v3password: Project name to scope to With
                        v3adfspassword: Project name to scope to With
                        v3oidcaccesstoken: Project name to scope to With
                        token: Project name to scope to With
                        v3oidcclientcredentials: Project name to scope to With
                        v3token: Project name to scope to With v3totp: Project
                        name to scope to With v3tokenlessauth: Project name to
                        scope to With v3oidcpassword: Project name to scope to
                        (Env: OS_PROJECT_NAME)
  --os-trust-id <auth-trust-id>
                        With v2token: Trust ID With password: Trust ID With
                        v3oidcauthcode: Trust ID With v2password: Trust ID
                        With v3samlpassword: Trust ID With v3password: Trust
                        ID With v3adfspassword: Trust ID With
                        v3oidcaccesstoken: Trust ID With token: Trust ID With
                        v3oidcclientcredentials: Trust ID With v3token: Trust
                        ID With v3totp: Trust ID With v3oidcpassword: Trust ID
                        (Env: OS_TRUST_ID)
  --os-service-provider-endpoint <auth-service-provider-endpoint>
                        With v3adfspassword: Service Provider's Endpoint (Env:
                        OS_SERVICE_PROVIDER_ENDPOINT)
  --os-domain-name <auth-domain-name>
                        With password: Domain name to scope to With
                        v3oidcauthcode: Domain name to scope to With
                        v3samlpassword: Domain name to scope to With
                        v3password: Domain name to scope to With
                        v3adfspassword: Domain name to scope to With
                        v3oidcaccesstoken: Domain name to scope to With token:
                        Domain name to scope to With v3oidcclientcredentials:
                        Domain name to scope to With v3token: Domain name to
                        scope to With v3totp: Domain name to scope to With
                        v3tokenlessauth: Domain name to scope to With
                        v3oidcpassword: Domain name to scope to (Env:
                        OS_DOMAIN_NAME)
  --os-user-domain-id <auth-user-domain-id>
                        With password: User's domain id With v3password:
                        User's domain id With v3totp: User's domain id (Env:
                        OS_USER_DOMAIN_ID)
  --os-access-token-type <auth-access-token-type>
                        With v3oidcauthcode: OAuth 2.0 Authorization Server
                        Introspection token type, it is used to decide which
                        type of token will be used when processing token
                        introspection. Valid values are: "access_token" or
                        "id_token" With v3oidcclientcredentials: OAuth 2.0
                        Authorization Server Introspection token type, it is
                        used to decide which type of token will be used when
                        processing token introspection. Valid values are:
                        "access_token" or "id_token" With v3oidcpassword:
                        OAuth 2.0 Authorization Server Introspection token
                        type, it is used to decide which type of token will be
                        used when processing token introspection. Valid values
                        are: "access_token" or "id_token" (Env:
                        OS_ACCESS_TOKEN_TYPE)
  --os-code <auth-code>
                        With v3oidcauthcode: OAuth 2.0 Authorization Code
                        (Env: OS_CODE)
  --os-identity-provider-url <auth-identity-provider-url>
                        With v3samlpassword: An Identity Provider URL, where
                        the SAML2 authentication request will be sent. With
                        v3adfspassword: An Identity Provider URL, where the
                        SAML authentication request will be sent. (Env:
                        OS_IDENTITY_PROVIDER_URL)
  --os-default-domain-name <auth-default-domain-name>
                        With password: Optional domain name to use with v3 API
                        and v2 parameters. It will be used for both the user
                        and project domain in v3 and ignored in v2
                        authentication. With token: Optional domain name to
                        use with v3 API and v2 parameters. It will be used for
                        both the user and project domain in v3 and ignored in
                        v2 authentication. (Env: OS_DEFAULT_DOMAIN_NAME)
  --os-access-token-endpoint <auth-access-token-endpoint>
                        With v3oidcauthcode: OpenID Connect Provider Token
                        Endpoint. Note that if a discovery document is being
                        passed this option will override the endpoint provided
                        by the server in the discovery document. With
                        v3oidcclientcredentials: OpenID Connect Provider Token
                        Endpoint. Note that if a discovery document is being
                        passed this option will override the endpoint provided
                        by the server in the discovery document. With
                        v3oidcpassword: OpenID Connect Provider Token
                        Endpoint. Note that if a discovery document is being
                        passed this option will override the endpoint provided
                        by the server in the discovery document. (Env:
                        OS_ACCESS_TOKEN_ENDPOINT)
  --os-access-token <auth-access-token>
                        With v3oidcaccesstoken: OAuth 2.0 Access Token (Env:
                        OS_ACCESS_TOKEN)
  --os-domain-id <auth-domain-id>
                        With password: Domain ID to scope to With
                        v3oidcauthcode: Domain ID to scope to With
                        v3samlpassword: Domain ID to scope to With v3password:
                        Domain ID to scope to With v3adfspassword: Domain ID
                        to scope to With v3oidcaccesstoken: Domain ID to scope
                        to With token: Domain ID to scope to With
                        v3oidcclientcredentials: Domain ID to scope to With
                        v3token: Domain ID to scope to With v3totp: Domain ID
                        to scope to With v3tokenlessauth: Domain ID to scope
                        to With v3oidcpassword: Domain ID to scope to (Env:
                        OS_DOMAIN_ID)
  --os-user-domain-name <auth-user-domain-name>
                        With password: User's domain name With v3password:
                        User's domain name With v3totp: User's domain name
                        (Env: OS_USER_DOMAIN_NAME)
  --os-openid-scope <auth-openid-scope>
                        With v3oidcauthcode: OpenID Connect scope that is
                        requested from authorization server. Note that the
                        OpenID Connect specification states that "openid" must
                        be always specified. With v3oidcclientcredentials:
                        OpenID Connect scope that is requested from
                        authorization server. Note that the OpenID Connect
                        specification states that "openid" must be always
                        specified. With v3oidcpassword: OpenID Connect scope
                        that is requested from authorization server. Note that
                        the OpenID Connect specification states that "openid"
                        must be always specified. (Env: OS_OPENID_SCOPE)
  --os-user-id <auth-user-id>
                        With password: User id With v2password: User ID to
                        login with With v3password: User ID With noauth: User
                        ID With v3totp: User ID With gnocchi-noauth: User ID
                        With aodh-noauth: User ID (Env: OS_USER_ID)
  --os-identity-provider <auth-identity-provider>
                        With v3oidcauthcode: Identity Provider's name With
                        v3samlpassword: Identity Provider's name With
                        v3adfspassword: Identity Provider's name With
                        v3oidcaccesstoken: Identity Provider's name With
                        v3oidcclientcredentials: Identity Provider's name With
                        v3oidcpassword: Identity Provider's name (Env:
                        OS_IDENTITY_PROVIDER)
  --os-username <auth-username>
                        With password: Username With v2password: Username to
                        login with With v3samlpassword: Username With
                        v3password: Username With v3adfspassword: Username
                        With v3totp: Username With v3oidcpassword: Username
                        (Env: OS_USERNAME)
  --os-auth-url <auth-auth-url>
                        With v2token: Authentication URL With password:
                        Authentication URL With v3oidcauthcode: Authentication
                        URL With v2password: Authentication URL With
                        v3samlpassword: Authentication URL With v3password:
                        Authentication URL With v3adfspassword: Authentication
                        URL With v3oidcaccesstoken: Authentication URL With
                        token: Authentication URL With
                        v3oidcclientcredentials: Authentication URL With
                        v3token: Authentication URL With v3totp:
                        Authentication URL With v3tokenlessauth:
                        Authentication URL With v3oidcpassword: Authentication
                        URL (Env: OS_AUTH_URL)
  --os-client-secret <auth-client-secret>
                        With v3oidcauthcode: OAuth 2.0 Client Secret With
                        v3oidcclientcredentials: OAuth 2.0 Client Secret With
                        v3oidcpassword: OAuth 2.0 Client Secret (Env:
                        OS_CLIENT_SECRET)
  --os-default-domain-id <auth-default-domain-id>
                        With password: Optional domain ID to use with v3 and
                        v2 parameters. It will be used for both the user and
                        project domain in v3 and ignored in v2 authentication.
                        With token: Optional domain ID to use with v3 and v2
                        parameters. It will be used for both the user and
                        project domain in v3 and ignored in v2 authentication.
                        (Env: OS_DEFAULT_DOMAIN_ID)
  --os-discovery-endpoint <auth-discovery-endpoint>
                        With v3oidcauthcode: OpenID Connect Discovery Document
                        URL. The discovery document will be used to obtain the
                        values of the access token endpoint and the
                        authentication endpoint. This URL should look like
                        https://idp.example.org/.well-known/openid-
                        configuration With v3oidcclientcredentials: OpenID
                        Connect Discovery Document URL. The discovery document
                        will be used to obtain the values of the access token
                        endpoint and the authentication endpoint. This URL
                        should look like https://idp.example.org/.well-known
                        /openid-configuration With v3oidcpassword: OpenID
                        Connect Discovery Document URL. The discovery document
                        will be used to obtain the values of the access token
                        endpoint and the authentication endpoint. This URL
                        should look like https://idp.example.org/.well-known
                        /openid-configuration (Env: OS_DISCOVERY_ENDPOINT)
  --os-client-id <auth-client-id>
                        With v3oidcauthcode: OAuth 2.0 Client ID With
                        v3oidcclientcredentials: OAuth 2.0 Client ID With
                        v3oidcpassword: OAuth 2.0 Client ID (Env:
                        OS_CLIENT_ID)
  --os-project-domain-name <auth-project-domain-name>
                        With password: Domain name containing project With
                        v3oidcauthcode: Domain name containing project With
                        v3samlpassword: Domain name containing project With
                        v3password: Domain name containing project With
                        v3adfspassword: Domain name containing project With
                        v3oidcaccesstoken: Domain name containing project With
                        token: Domain name containing project With
                        v3oidcclientcredentials: Domain name containing
                        project With v3token: Domain name containing project
                        With v3totp: Domain name containing project With
                        v3tokenlessauth: Domain name containing project With
                        v3oidcpassword: Domain name containing project (Env:
                        OS_PROJECT_DOMAIN_NAME)
  --os-service-provider-entity-id <auth-service-provider-entity-id>
                        With v3adfspassword: Service Provider's SAML Entity ID
                        (Env: OS_SERVICE_PROVIDER_ENTITY_ID)
  --os-password <auth-password>
                        With password: User's password With v2password:
                        Password to use With v3samlpassword: Password With
                        v3password: User's password With v3adfspassword:
                        Password With v3oidcpassword: Password (Env:
                        OS_PASSWORD)
  --os-redirect-uri <auth-redirect-uri>
                        With v3oidcauthcode: OpenID Connect Redirect URL (Env:
                        OS_REDIRECT_URI)
  --os-endpoint <auth-endpoint>
                        With admin_token: The endpoint that will always be
                        used With noauth: Cinder endpoint With gnocchi-noauth:
                        Gnocchi endpoint With gnocchi-basic: Gnocchi endpoint
                        (Env: OS_ENDPOINT)
  --os-aodh-endpoint <auth-aodh-endpoint>
                        With aodh-noauth: Aodh endpoint (Env:
                        OS_AODH_ENDPOINT)
  --os-roles <auth-roles>
                        With gnocchi-noauth: Roles With aodh-noauth: Roles
                        (Env: OS_ROLES)
  --os-url <auth-url>   With token_endpoint: Specific service endpoint to use
                        (Env: OS_URL)
  --os-token <auth-token>
                        With v2token: Token With admin_token: The token that
                        will always be used With token_endpoint:
                        Authentication token to use With token: Token to
                        authenticate with With v3token: Token to authenticate
                        with (Env: OS_TOKEN)
  --os-passcode <auth-passcode>
                        With v3totp: User's TOTP passcode (Env: OS_PASSCODE)
  --os-project-id <auth-project-id>
                        With password: Project ID to scope to With
                        v3oidcauthcode: Project ID to scope to With
                        v3samlpassword: Project ID to scope to With
                        v3password: Project ID to scope to With
                        v3adfspassword: Project ID to scope to With
                        v3oidcaccesstoken: Project ID to scope to With token:
                        Project ID to scope to With v3oidcclientcredentials:
                        Project ID to scope to With noauth: Project ID With
                        v3token: Project ID to scope to With v3totp: Project
                        ID to scope to With v3tokenlessauth: Project ID to
                        scope to With gnocchi-noauth: Project ID With
                        v3oidcpassword: Project ID to scope to With aodh-
                        noauth: Project ID (Env: OS_PROJECT_ID)
  --os-user <auth-user>
                        With gnocchi-basic: User (Env: OS_USER)

Commands:
  address scope create  Create a new Address Scope
  address scope delete  Delete address scope(s)
  address scope list  List address scopes
  address scope set  Set address scope properties
  address scope show  Display address scope details
  aggregate add host  Add host to aggregate
  aggregate create  Create a new aggregate
  aggregate delete  Delete existing aggregate(s)
  aggregate list  List all aggregates
  aggregate remove host  Remove host from aggregate
  aggregate set  Set aggregate properties
  aggregate show  Display aggregate details
  aggregate unset  Unset aggregate properties
  alarm create   Create an alarm (aodhclient)
  alarm delete   Delete an alarm (aodhclient)
  alarm list     List alarms (aodhclient)
  alarm show     Show an alarm (aodhclient)
  alarm state get  Get state of an alarm (aodhclient)
  alarm state set  Set state of an alarm (aodhclient)
  alarm update   Update an alarm (aodhclient)
  alarm-history search  Show history for all alarms based on query (aodhclient)
  alarm-history show  Show history for an alarm (aodhclient)
  alarming capabilities list  List capabilities of alarming service (aodhclient)
  availability zone list  List availability zones and their status
  catalog list   List services in the service catalog
  catalog show   Display service catalog details
  command list   List recognized commands by group
  complete       print bash completion command (cliff)
  compute agent create  Create compute agent
  compute agent delete  Delete compute agent(s)
  compute agent list  List compute agents
  compute agent set  Set compute agent properties
  compute service delete  Delete compute service(s)
  compute service list  List compute services
  compute service set  Set compute service properties
  configuration show  Display configuration details
  consistency group add volume  Add volume(s) to consistency group
  consistency group create  Create new consistency group.
  consistency group delete  Delete consistency group(s).
  consistency group list  List consistency groups.
  consistency group remove volume  Remove volume(s) from consistency group
  consistency group set  Set consistency group properties
  consistency group show  Display consistency group details.
  consistency group snapshot create  Create new consistency group snapshot.
  consistency group snapshot delete  Delete consistency group snapshot(s).
  consistency group snapshot list  List consistency group snapshots.
  consistency group snapshot show  Display consistency group snapshot details
  console log show  Show server's console output
  console url show  Show server's remote console URL
  container create  Create new container
  container delete  Delete container
  container list  List containers
  container save  Save container contents locally
  container set  Set container properties
  container show  Display container details
  container unset  Unset container properties
  ec2 credentials create  Create EC2 credentials
  ec2 credentials delete  Delete EC2 credentials
  ec2 credentials list  List EC2 credentials
  ec2 credentials show  Display EC2 credentials details
  endpoint create  Create new endpoint
  endpoint delete  Delete endpoint(s)
  endpoint list  List endpoints
  endpoint show  Display endpoint details
  event capabilities list  List capabilities for event service (pankoclient)
  event list     List events (pankoclient)
  event show     List events (pankoclient)
  event type list  List event types (pankoclient)
  extension list  List API extensions
  extension show  Show API extension
  flavor create  Create new flavor
  flavor delete  Delete flavor(s)
  flavor list    List flavors
  flavor set     Set flavor properties
  flavor show    Display flavor details
  flavor unset   Unset flavor properties
  floating ip create  Create floating IP
  floating ip delete  Delete floating IP(s)
  floating ip list  List floating IP(s)
  floating ip pool list  List pools of floating IP addresses
  floating ip set  Set floating IP Properties
  floating ip show  Display floating IP details
  floating ip unset  Unset floating IP Properties
  help           print detailed help for another command (cliff)
  host list      List hosts
  host set       Set host properties
  host show      Display host details
  hypervisor list  List hypervisors
  hypervisor show  Display hypervisor details
  hypervisor stats show  Display hypervisor stats details
  image add project  Associate project with image
  image create   Create/upload an image
  image delete   Delete image(s)
  image list     List available images
  image remove project  Disassociate project with image
  image save     Save an image locally
  image set      Set image properties
  image show     Display image details
  image unset    Unset image tags and properties
  ip availability list  List IP availability for network
  ip availability show  Show network IP availability details
  keypair create  Create new public or private key for server ssh access
  keypair delete  Delete public or private key(s)
  keypair list   List key fingerprints
  keypair show   Display key details
  limits show    Show compute and block storage limits
  metric aggregates  Get measurements of aggregated metrics (gnocchiclient)
  metric archive-policy create  Create an archive policy (gnocchiclient)
  metric archive-policy delete  Delete an archive policy (gnocchiclient)
  metric archive-policy list  List archive policies (gnocchiclient)
  metric archive-policy show  Show an archive policy (gnocchiclient)
  metric archive-policy update  Update an archive policy (gnocchiclient)
  metric archive-policy-rule create  Create an archive policy rule (gnocchiclient)
  metric archive-policy-rule delete  Delete an archive policy rule (gnocchiclient)
  metric archive-policy-rule list  List archive policy rules (gnocchiclient)
  metric archive-policy-rule show  Show an archive policy rule (gnocchiclient)
  metric benchmark measures add  Do benchmark testing of adding measurements (gnocchiclient)
  metric benchmark measures show  Do benchmark testing of measurements show (gnocchiclient)
  metric benchmark metric create  Do benchmark testing of metric creation (gnocchiclient)
  metric benchmark metric show  Do benchmark testing of metric show (gnocchiclient)
  metric capabilities list  List capabilities (gnocchiclient)
  metric create  Create a metric (gnocchiclient)
  metric delete  Delete a metric (gnocchiclient)
  metric list    List metrics (gnocchiclient)
  metric measures add  Add measurements to a metric (gnocchiclient)
  metric measures aggregation  Get measurements of aggregated metrics (gnocchiclient)
  metric measures batch-metrics   (gnocchiclient)
  metric measures batch-resources-metrics   (gnocchiclient)
  metric measures show  Get measurements of a metric (gnocchiclient)
  metric metric create  Deprecated: Create a metric (gnocchiclient)
  metric metric delete  Deprecated: Delete a metric (gnocchiclient)
  metric metric list  Deprecated: List metrics (gnocchiclient)
  metric metric show  Deprecated: Show a metric (gnocchiclient)
  metric resource batch delete  Delete a batch of resources based on attribute values (gnocchiclient)
  metric resource create  Create a resource (gnocchiclient)
  metric resource delete  Delete a resource (gnocchiclient)
  metric resource history  Show the history of a resource (gnocchiclient)
  metric resource list  List resources (gnocchiclient)
  metric resource search  Search resources with specified query rules (gnocchiclient)
  metric resource show  Show a resource (gnocchiclient)
  metric resource update  Update a resource (gnocchiclient)
  metric resource-type create  Create a resource type (gnocchiclient)
  metric resource-type delete  Delete a resource type (gnocchiclient)
  metric resource-type list  List resource types (gnocchiclient)
  metric resource-type show  Show a resource type (gnocchiclient)
  metric resource-type update   (gnocchiclient)
  metric server version  Show the version of Gnocchi server (gnocchiclient)
  metric show    Show a metric (gnocchiclient)
  metric status  Show the status of measurements processing (gnocchiclient)
  module list    List module versions
  network agent add network  Add network to an agent
  network agent add router  Add router to an agent
  network agent delete  Delete network agent(s)
  network agent list  List network agents
  network agent remove network  Remove network from an agent.
  network agent remove router  Remove router from an agent
  network agent set  Set network agent properties
  network agent show  Display network agent details
  network auto allocated topology create  Create the  auto allocated topology for project
  network auto allocated topology delete  Delete auto allocated topology for project
  network create  Create new network
  network delete  Delete network(s)
  network flavor add profile  Add a service profile to a network flavor
  network flavor create  Create new network flavor
  network flavor delete  Delete network flavors
  network flavor list  List network flavors
  network flavor profile create  Create new network flavor profile
  network flavor profile delete  Delete network flavor profile
  network flavor profile list  List network flavor profile(s)
  network flavor profile set  Set network flavor profile properties
  network flavor profile show  Display network flavor profile details
  network flavor remove profile  Remove service profile from network flavor
  network flavor set  Set network flavor properties
  network flavor show  Display network flavor details
  network list   List networks
  network meter create  Create network meter
  network meter delete  Delete network meter
  network meter list  List network meters
  network meter rule create  Create a new meter rule
  network meter rule delete  Delete meter rule(s)
  network meter rule list  List meter rules
  network meter rule show  Display meter rules details
  network meter show  Show network meter
  network qos policy create  Create a QoS policy
  network qos policy delete  Delete Qos Policy(s)
  network qos policy list  List QoS policies
  network qos policy set  Set QoS policy properties
  network qos policy show  Display QoS policy details
  network qos rule create  Create new Network QoS rule
  network qos rule delete  Delete Network QoS rule
  network qos rule list  List Network QoS rules
  network qos rule set  Set Network QoS rule properties
  network qos rule show  Display Network QoS rule details
  network qos rule type list  List QoS rule types
  network qos rule type show  Show details about supported QoS rule type
  network rbac create  Create network RBAC policy
  network rbac delete  Delete network RBAC policy(s)
  network rbac list  List network RBAC policies
  network rbac set  Set network RBAC policy properties
  network rbac show  Display network RBAC policy details
  network segment create  Create new network segment
  network segment delete  Delete network segment(s)
  network segment list  List network segments
  network segment set  Set network segment properties
  network segment show  Display network segment details
  network service provider list  List Service Providers
  network set    Set network properties
  network show   Show network details
  network unset  Unset network properties
  object create  Upload object to container
  object delete  Delete object from container
  object list    List objects
  object save    Save object locally
  object set     Set object properties
  object show    Display object details
  object store account set  Set account properties
  object store account show  Display account details
  object store account unset  Unset account properties
  object unset   Unset object properties
  port create    Create a new port
  port delete    Delete port(s)
  port list      List ports
  port set       Set port properties
  port show      Display port details
  port unset     Unset port properties
  project create  Create new project
  project delete  Delete project(s)
  project list   List projects
  project purge  Clean resources associated with a project
  project set    Set project properties
  project show   Display project details
  project unset  Unset project properties
  quota list     List quotas for all projects with non-default quota values
  quota set      Set quotas for project or class
  quota show     Show quotas for project or class
  role add       Add role to project:user
  role assignment list  List role assignments
  role create    Create new role
  role delete    Delete role(s)
  role list      List roles
  role remove    Remove role from project : user
  role show      Display role details
  router add port  Add a port to a router
  router add subnet  Add a subnet to a router
  router create  Create a new router
  router delete  Delete router(s)
  router list    List routers
  router remove port  Remove a port from a router
  router remove subnet  Remove a subnet from a router
  router set     Set router properties
  router show    Display router details
  router unset   Unset router properties
  security group create  Create a new security group
  security group delete  Delete security group(s)
  security group list  List security groups
  security group rule create  Create a new security group rule
  security group rule delete  Delete security group rule(s)
  security group rule list  List security group rules
  security group rule show  Display security group rule details
  security group set  Set security group properties
  security group show  Display security group details
  server add fixed ip  Add fixed IP address to server
  server add floating ip  Add floating IP address to server
  server add network  Add network to server
  server add port  Add port to server
  server add security group  Add security group to server
  server add volume  Add volume to server
  server backup create  Create a server backup image
  server create  Create a new server
  server delete  Delete server(s)
  server dump create  Create a dump file in server(s)
  server event list  List recent events of a server
  server event show  Show server event details
  server group create  Create a new server group.
  server group delete  Delete existing server group(s).
  server group list  List all server groups.
  server group show  Display server group details.
  server image create  Create a new server disk image from an existing server
  server list    List servers
  server lock    Lock server(s). A non-admin user will not be able to execute actions
  server migrate  Migrate server to different host
  server pause   Pause server(s)
  server reboot  Perform a hard or soft server reboot
  server rebuild  Rebuild server
  server remove fixed ip  Remove fixed IP address from server
  server remove floating ip  Remove floating IP address from server
  server remove network  Remove all ports of a network from server
  server remove port  Remove port from server
  server remove security group  Remove security group from server
  server remove volume  Remove volume from server
  server rescue  Put server in rescue mode
  server resize  Scale server to a new flavor.
  server restore  Restore server(s)
  server resume  Resume server(s)
  server set     Set server properties
  server shelve  Shelve server(s)
  server show    Show server details
  server ssh     SSH to server
  server start   Start server(s).
  server stop    Stop server(s).
  server suspend  Suspend server(s)
  server unlock  Unlock server(s)
  server unpause  Unpause server(s)
  server unrescue  Restore server from rescue mode
  server unset   Unset server properties
  server unshelve  Unshelve server(s)
  service create  Create new service
  service delete  Delete service(s)
  service list   List services
  service show   Display service details
  snapshot create  Create new snapshot
  snapshot delete  Delete volume snapshot(s)
  snapshot list  List snapshots
  snapshot set   Set snapshot properties
  snapshot show  Display snapshot details
  snapshot unset  Unset snapshot properties
  subnet create  Create a subnet
  subnet delete  Delete subnet(s)
  subnet list    List subnets
  subnet pool create  Create subnet pool
  subnet pool delete  Delete subnet pool(s)
  subnet pool list  List subnet pools
  subnet pool set  Set subnet pool properties
  subnet pool show  Display subnet pool details
  subnet pool unset  Unset subnet pool properties
  subnet set     Set subnet properties
  subnet show    Display subnet details
  subnet unset   Unset subnet properties
  token issue    Issue new token
  token revoke   Revoke existing token
  usage list     List resource usage per project
  usage show     Show resource usage for a single project
  user create    Create new user
  user delete    Delete user(s)
  user list      List users
  user role list  List user-role assignments
  user set       Set user properties
  user show      Display user details
  volume backup create  Create new volume backup
  volume backup delete  Delete volume backup(s)
  volume backup list  List volume backups
  volume backup restore  Restore volume backup
  volume backup set  Set volume backup properties
  volume backup show  Display volume backup details
  volume create  Create new volume
  volume delete  Delete volume(s)
  volume host failover  Failover volume host to different backend
  volume host set  Set volume host properties
  volume list    List volumes
  volume migrate  Migrate volume to a new host
  volume qos associate  Associate a QoS specification to a volume type
  volume qos create  Create new QoS specification
  volume qos delete  Delete QoS specification
  volume qos disassociate  Disassociate a QoS specification from a volume type
  volume qos list  List QoS specifications
  volume qos set  Set QoS specification properties
  volume qos show  Display QoS specification details
  volume qos unset  Unset QoS specification properties
  volume service list  List service command
  volume service set  Set volume service properties
  volume set     Set volume properties
  volume show    Display volume details
  volume snapshot create  Create new volume snapshot
  volume snapshot delete  Delete volume snapshot(s)
  volume snapshot list  List volume snapshots
  volume snapshot set  Set volume snapshot properties
  volume snapshot show  Display volume snapshot details
  volume snapshot unset  Unset volume snapshot properties
  volume transfer request accept  Accept volume transfer request.
  volume transfer request create  Create volume transfer request.
  volume transfer request delete  Delete volume transfer request(s).
  volume transfer request list  Lists all volume transfer requests.
  volume transfer request show  Show volume transfer request details.
  volume type create  Create new volume type
  volume type delete  Delete volume type(s)
  volume type list  List volume types
  volume type set  Set volume type properties
  volume type show  Display volume type details
  volume type unset  Unset volume type properties
  volume unset   Unset volume properties
