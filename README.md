# docker-sonar-scanner

Enables integration with SonarQube.

### Usage

Insert the snippet below after your build step in your .drone.yml, copy the sonar-project.properties to your project and fill out the missing bits.

```
  sonar-scanner:
    image: quay.io/ukhomeofficedigital/sonar-scanner:v3.0.1
    when:
      event:
        - push
        - pull_request
```

### Versioning
The container image will be based on the sonar-scanner release version as outlined on https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/

However, due to automated ACP build processes and other dependencies such as JDK and Node the tag following tag format will be used:
`<Sonar Scanner Version>-build.x` where x is an incrementing integer

Upon satisfactory testing, the build version will be promoted to both the sonar-scanner version tag and latest in quay.io

Versioning will be maintained by updating the `.semver` file. E.g. should Sonar Scanner 3.99.999 release, the `.semver` file will need to be `3.99.999-build.0`

#### Updating Sonar Version
Remember to calculate the sha512sum of the newer sonar binary and update it within the drone pipeline - Environment Variable `SONAR_SCANNER_SHA512`
