# vault-helm

The project provides an operator based on the helm chart for deploying and managing Hasicorp vault.

| Component          | Version |
| ------------------ | ------- |
| Helm Chart         | 0.8.0   |
| Kubernetes Minimum | 1.17    |
| RedHat OCP         | 4.4.17  |

The operator deploys a custom resource definition of kind `vaults.vault.sdbrett.com` when first deployed onto a Kubernetes cluster.

The operator watches the namespace that it was deployed into for the creation, update or removal of objects of kind `vaults.vault.sdbrett.com`. Helm is executed using the values contained within the `vaults` object.

| Event          | Helm Action    |
| -------------- | -------------- |
| Object created | Helm Install   |
| Object updated | Helm Upgrade   |
| Object removed | Helm Uninstall |

## Specifying Values

The operator passes anything in the Vaults object under `.spec` to Helm as values. Refer to the Vault helm chart for configuration value information. [Values.yaml on Github](https://github.com/hashicorp/vault-helm/blob/v0.8.0/values.yaml)

*Sample vaults object*

```
apiVersion: vault.sdbrett.com/v1alpha1
kind: Vault
metadata:
  name: vault-sample
spec:
  # Default values copied from <project_dir>/helm-charts/vault/values.yaml
  global:
    enabled: true
    openshift: true
  server:
    standalone:
      enabled: true
    route:
      enabled: true
      host: vault
    service:
      enabled: true
      port: 8200
      targetPort: 8200
    dataStorage:
      accessMode: ReadWriteOnce
      enabled: true
      mountPath: /vault/data
      size: 10Gi      
```

## Additional Resources

[Hashicorp Vault Documentation](https://www.vaultproject.io/docs/platform/k8s/helm)
[Hashicorp Vault Github](https://github.com/hashicorp/vault-helm)