Usage:
  helm init [flags]

Flags:
      --canary-image             use the canary Tiller image
  -c, --client-only              if set does not install Tiller
      --dry-run                  do not install local or remote
      --history-max int          limit the maximum number of revisions saved per release. Use 0 for no limit.
      --local-repo-url string    URL for local repository (default "http://127.0.0.1:8879/charts")
      --net-host                 install Tiller with net=host
      --node-selectors string    labels to specify the node on which Tiller is installed (app=tiller,helm=rocks)
  -o, --output OutputFormat      skip installation and output Tiller's manifest in specified format (json or yaml)
      --override stringArray     override values for the Tiller Deployment manifest (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --service-account string   name of service account
      --skip-refresh             do not refresh (download) the local repository cache
      --stable-repo-url string   URL for stable repository (default "https://kubernetes-charts.storage.googleapis.com")
  -i, --tiller-image string      override Tiller image
      --tiller-tls               install Tiller with TLS enabled
      --tiller-tls-cert string   path to TLS certificate file to install with Tiller
      --tiller-tls-key string    path to TLS key file to install with Tiller
      --tiller-tls-verify        install Tiller with TLS enabled and to verify remote certificates
      --tls-ca-cert string       path to CA root certificate
      --upgrade                  upgrade if Tiller is already installed

Global Flags:
      --debug                     enable verbose output
      --home string               location of your Helm config. Overrides $HELM_HOME (default "/root/.helm")
      --host string               address of Tiller. Overrides $HELM_HOST
      --kube-context string       name of the kubeconfig context to use
      --tiller-namespace string   namespace of Tiller (default "kube-system")
