# docker-sonar-scanner

Enables integration with SonarQube.

### Usage

Insert the snippet below after your build step in your .drone.yml

```
  sonar-scanner:
    commands:
       - "sonar-scanner"
    image: quay.io/ukhomeofficedigital/sonar-scanner:v0.0.1
    when:
      event:
        - push
        - pull_request
```
