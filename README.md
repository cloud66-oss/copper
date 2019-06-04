# Copper

## Copper is a configuration validator for Kubernetes by Cloud 66

### What is Copper?

Copper is a configuration validator for Kubernetes by [Cloud 66](https://cloud66.com).

### Why do I need Copper?

We built Copper to achieve 2 main goals:

- Let developers make changes to Kubernetes configuration files as needed instead of restricting what they can do with another layer of APIs on top.
- Make sure all configuration files applied to the Kubernetes clusters are tested and adhere to the relevant infrastructure policies.

In short, we thought if _infrastructure as code_ is the right way to go, then we need to apply the same principles we use for code to infrastructure configuration as well.

If you use systems like Kubernetes, commit configuration files into a code repository and want to rest peacefully at night knowing your configurations are always tested, then you need Copper.

#### What to validate with Kubernetes configuration files?

These are some of the things we check in our configuration files committed into our git repository:

- `latest` is not used as the image tag for any Deployment
- Image versions are not changed for important components (like databases) except for minor versions and patches.
- Load balancer IP address is not changed in Service configuration by mistake
- Any fixed IP address used is within a valid range
- No secret is committed into the configuration repository. We use [Skycao](https://cloud66.com/skycap) to replace those later on a secure machine.
- Certain images come from our trusted repositories and not public ones.

For us these checks are like unit tests: they are there to make sure changes are made with confidence and human or machine errors are mitigated. Obviously these are not security measures and should be developed and treated exactly like your CI code tests.

### How do I use Copper?

You can use Copper as a command line or docker image, integrating it with you CI/CD or as a library in your own code.

### A Basic Example

This is a very simple Kubernetes configuration file. We have saved it as `deploy.yml`:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
    namespace: foobar
    name: foo
spec:
    template:
        spec:
            containers:
            - name: mysql
                image: index.docker.io/library/mysql:6.5.0
```

As this configuration file is changed, we want to make sure the image tag for MySQL is never set to `latest`.

To do this, we use Copper's simple DSL to check the configuration validation:

```javascript
rule NoLatest ensure {  // use of latest as image tag is not allowed
    fetch("$.spec.template.spec.containers..image")
        .as(:image)
        .pick(:tag)
        .contains("latest") == false
    }
```

Save this file as `my_rules.cop` and run Copper CLI:

```bash
copper check --rules my_rules.cop --file deploy.yml
```

Here is what you will see:

```text
Validating part 0
    noLatest - PASS
```

### Can I use Copper for configuration files other than Kubernetes?

Absolutely! While Copper DSL has features that are very useful for Kubernetes configuration file validation, like IP Address parsing or build-in Semantic Version support for Docker images, there is nothing specific in Copper that's locked in to Kubernetes. Currently Copper supports YAML configuration files, but adding new types like JSON or Toml is very easy.

### More Documentation

Checkout the Wiki section of this repository for more information on how to use Copper.

### Who are you?

Copper is an open source project developed and used by [Cloud 66](https://cloud66.com). It is distributed under MPL 2.0 license.
