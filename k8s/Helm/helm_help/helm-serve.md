Usage:
  helm serve [flags]

Flags:
      --address string     address to listen on (default "127.0.0.1:8879")
      --repo-path string   local directory path from which to serve charts
      --url string         external URL of chart repository

Global Flags:
      --debug                     enable verbose output
      --home string               location of your Helm config. Overrides $HELM_HOME (default "/root/.helm")
      --host string               address of Tiller. Overrides $HELM_HOST
      --kube-context string       name of the kubeconfig context to use
      --tiller-namespace string   namespace of Tiller (default "kube-system")