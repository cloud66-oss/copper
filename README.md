<img src="http://cdn2-cloud66-com.s3.amazonaws.com/images/oss-sponsorship.png" width=150/>

# Copper

Copper is a simple tool for validate your configuration files. This is specifically useful with Kubernetes configuration files to enforce best practices, apply policies and compliance requirements.

NOTE: This is Copper v2.0 which is a rewrite of Copper v1.0 (and not an in-place upgrade). Copper v2.0 uses Javascript as it's scripting language instead of Copper v1.0's custom DSL. At the moment, we don't offer any upgrades for old Copper v1 scripts to Copper v2.


![Copper Logo](https://blog.cloud66.com/content/images/2019/07/cloud66-copper.png)


## Installation

Head to the releases section of this repository and download the latest version of Copper. You can update Copper using `copper update` command at any time. By default, you will be running the `stable` releases. To change the channel, you can use the `--channel` argument in `copper update`.

## Usage

```bash
copper validate --in samples/sample.yml --validator samples/no_latest.js
```

This will run `no_latest.js` script to validate `sample.yml` (both available in this repository).

Copper supports YAML configuration files. By default, it loads the entire input YAML file into the `$$` variable that's available to your scripts. Each section of your YAML file is one item in the `$$` array.

Here is an example on how to stop using `latest` as the image tag.

```javascript
$$.forEach(function($){
    if ($.kind === 'Deployment') {
        $.spec.template.spec.containers.forEach(function(container) {
            var image = new DockerImage(container.image);
            if (image.tag === 'latest') {
                errors.add_error('no_latest',"latest is used in " + $.metadata.name, 1)
            }
        });
    }
});
```

As you can see, for each section in the YAML, we check if the item is a `Deployment`, if it is use one of Copper's internal helper classes `DocerkImage` to load the image name and parse it. `DockerImage` understands the intricacies of Docker image names (default tag names, default repos, etc). If the tag is `latest` we push an error into the `errors` list.

Once our script has run, Copper will check `errors` for any errors.

Each validation error should have 3 attributes:
`check_name`: The name of the check we just performed
`title`: Some explanation about this error
`severity`: A numerical representation of the severity of this error.

You can set the maximum allowed severity when running Copper using the `--threshold` argument.

### Helpers

To see what helpers are available for you to use in your scripts, see the files in the `libjs` folder in the repository. All these files are loaded before your script is run and therefore are available to use within your scripts.
