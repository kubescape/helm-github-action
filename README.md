# Kubescape action

Run security scans on your Kubernetes manifests and Helm charts as a part of your CI using the Kubescape action. Kubescape scans Kubernetes clusters, YAML files, and HELM charts, detecting misconfigurations according to multiple frameworks (such as the [NSA-CISA](https://www.armosec.io/blog/kubernetes-hardening-guidance-summary-by-armo/?utm_source=github&utm_medium=repository) , [MITRE ATT&CK®](https://www.microsoft.com/security/blog/2021/03/23/secure-containerized-environments-with-updated-threat-matrix-for-kubernetes/) and [CIS Benchmark](https://www.armosec.io/blog/kubescape-adds-cis-benchmark/?utm_source=github&utm_medium=repository)), software vulnerabilities. 

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
| chartName | The name of the Helm chart. The files need to be provided with the complete path from the root of the repository. | Yes |
| chartPath | The path to the Helm chart. The path needs to be the complete path from the root of the repository. | Yes |
| helmArgs | The arguments to be passed to Helm. These are usually the values for the Helm chart that need to be substituted during the scan without which the chart would not be complete. | Yes |
| threshold | Failure threshold is the percent above which the command fails and returns exit code 1 (default 0 i.e, action fails if any control fails) | No (default 0) |
| framework | The security framework(s) to scan the files against. Multiple frameworks can be specified separated by a comma with no spaces. Example - `nsa,devopsbest`. Run `kubescape list frameworks` with the [Kubescape CLI](https://hub.armo.cloud/docs/installing-kubescape) to get a list of all frameworks. Either frameworks or controls have to be specified. | No |
| control | The security control(s) to scan the files against. Multiple controls can be specified separated by a comma with no spaces. Example - `Configured liveness probe,Pods in default namespace`. Run `kubescape list controls` with the [Kubescape CLI](https://hub.armo.cloud/docs/installing-kubescape) to get a list of all controls. You can specify either the complete control name or the contorl ID such as `C-0001`. Either controls or frameworks need to be specified. | No |
| kubescapeArgs | Additional arguments for the Kubescape CLI. The following arguments are supported - <ul><li>` -f, --format` - Output format. Supported formats: "pretty-printer"/"json"/"junit"/"prometheus" (default "pretty-printer")</li><li>`-o, --output` - Output file. Print output to file and not stdout</li><li>`--exceptions` - Provide path to an [exception](https://hub.armo.cloud/docs/exceptions) object.</li><li>` -s, --silent` - Silent progress messages</li><li>`--verbose` - Display all of the input resources and not only failed resources</li><li>`--logger` - Logger level. Supported: debug/info/success/warning/error/fatal (default "info")</li></ul> | No |

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

- With Kubescape arguments

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

- With Helm arguments for providing values for the Helm chart

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
name: Scan YAML files using Kubescape against specific frameworks
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

- Specifying controls

```yaml
name: Scan YAML files using Kubescape against specific controls
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

- Store the results in a file as an artifact

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
