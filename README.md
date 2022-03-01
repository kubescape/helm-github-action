# Kubescape action

Run security scans on your Kubernetes manifests and Helm charts as a part of your CI using the Kubescape action. Kubescape scans K8s clusters, YAML files, and HELM charts, detecting misconfigurations according to multiple frameworks (such as the [NSA-CISA](https://www.armosec.io/blog/kubernetes-hardening-guidance-summary-by-armo) , [MITRE ATT&CK®](https://www.microsoft.com/security/blog/2021/03/23/secure-containerized-environments-with-updated-threat-matrix-for-kubernetes/)), software vulnerabilities. 

## Usage

Add the following step to your workflow configuration:

```yaml
steps:
  - uses: actions/checkout@v2 
  - uses: avinashupadhya99/kubescape-helm-action@main
    with:
      files: kubernetes/*.yaml
```

## Inputs

| Name | Description | Required |
| --- | --- | ---|
| chartName | The name of the helm chart. The files need to be provided with the complete path from the root of the repository. | Yes |
| chartPath | The path to the helm chart. The path need to be the complete path from the root of the repository. | Yes |
| helmArgs | The arguments to be passed to helm. These usually are the values for the helm chart that need to be substituted during the scan without which the chart would not be complete. | Yes |
| threshold | Failure threshold is the percent above which the command fails and returns exit code 1 (default 0 i.e, action fails if any control fails) | No (default 0) |
| framework | The security framework(s) to scan the files against. Multiple frameworks can be specified separated by a comma with no spaces. Example - `nsa,devopsbest`. Run `kubescape list frameworks` with the [Kubescape CLI](https://hub.armo.cloud/docs/installing-kubescape) to get a list of all frameworks. Either frameworks have to be specified or controls. | No |
| control | The security control(s) to scan the files against. Multiple controls can be specified separated by a comma with no spaces. Example - `Configured liveness probe,Pods in default namespace`. Run `kubescape list controls` with the [Kubescape CLI](https://hub.armo.cloud/docs/installing-kubescape) to get a list of all controls. The complete control name can be specified or the ID such as `C-0001` can be specified. Either controls have to be specified or frameworks. | No |
| kubescapeArgs | Additional arguments to the Kubescape CLI. The following arguments are supported - <ul><li>` -f, --format` - Output format. Supported formats: "pretty-printer"/"json"/"junit"/"prometheus" (default "pretty-printer")</li><li>`-o, --output` - Output file. Print output to file and not stdout</li><li>`--exceptions` - Provide path to an [exception](https://hub.armo.cloud/docs/exceptions) object.</li><li>` -s, --silent` - Silent progress messages</li><li>`--verbose` - Display all of the input resources and not only failed resources</li><li>`--logger` - Logger level. Supported: debug/info/success/warning/error/fatal (default "info")</li></ul> | No |

## Examples

- Standard

```yaml
name: Scan helm chart with Kubescape
on: push

jobs:
  kubescape:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: avinashupadhya99/kubescape-helm-action@main
        with:
          chartName: armo
          chartPath: "charts/armo-components/"
```

- With kubescape arguments

```yaml
name: Scan YAML files using Kubescape with additional kubescape arguments
on: push

jobs:
  kubescape:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: avinashupadhya99/kubescape-helm-action@main
        with:
          kubescapeArgs: "--format junit --output results.xml"
          chartName: armo
          chartPath: "charts/armo-components/"
```

- With helm arguments for providing values for the helm chart

```yaml
name: Scan YAML files using Kubescape with additional helm arguments
on: push

jobs:
  kubescape:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: avinashupadhya99/kubescape-helm-action@main
        with:
          chartName: armo
          chartPath: "charts/armo-components/"
          helmArgs: "--set accountGuid=xxxx-xxxx-xxxx-xxxx"
```

- Specifying frameworks

```yaml
name: Scan YAML files using Kubescape and against specific frameworks
on: push

jobs:
  kubescape:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: avinashupadhya99/kubescape-helm-action@main
        with:
          chartName: armo
          chartPath: "charts/armo-components/"
          framework: |
            nsa,devopsbest
```

- Specific controls

```yaml
name: Scan YAML files using Kubescape and for specific controls
on: push

jobs:
  kubescape:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: avinashupadhya99/kubescape-helm-action@main
        with:
          chartName: armo
          chartPath: "charts/armo-components/"
          control: |
            Configured liveness probe,Pods in default namespace,Bash/cmd inside container
```

- Store the results in a file as an artifacts

```yaml
name: Scan YAML files with Kubescape and store results as an artifact
on: push

jobs:
  kubescape:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: avinashupadhya99/kubescape-helm-action@main
        with:
          args: "--format junit --output results.xml"
          chartName: armo
          chartPath: "charts/armo-components/"
          framework: nsa
      - name: Archive kubescape scan results
        uses: actions/upload-artifact@v2
        with:
          name: kubescape-scan-report
          path: results.xml
```

- View the results in GitHub as test results

```yaml
name: Scan YAML files with Kubescape and store results as an artifact
on: push

jobs:
  kubescape:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: avinashupadhya99/kubescape-helm-action@main
        with:
          args: "--format junit --output results.xml"
          chartName: armo
          chartPath: "charts/armo-components/"
          framework: nsa
      - name: Publish Unit Test Results
        uses: mikepenz/action-junit-report@v2
        if: always()
        with:
          report_paths: "*.xml"
```

## License

[//]: TODO
