# docker-sonar-scanner

Enables integration with SonarQube.

### Usage

Insert the snippet below after your build step in your .drone.yml, and copy the sonar-project.properties to your project and fill out the missing bits.

```
  sonar-scanner:
    image: quay.io/ukhomeofficedigital/sonar-scanner:v0.0.2
    when:
      event:
        - push
        - pull_request
```
