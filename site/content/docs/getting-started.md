+++
title = "Getting Started"
description = "Taking the first steps to validate your Kubernetes configuration files"
date = 2018-03-19T10:52:22Z
weight = 20
draft = false
bref = "Taking the first steps to validate your Kubernetes configuration files"
toc = false
+++

## Overview

Copper validates configuration files using **Rules**. Rules are descriptions of what you would like to see (or don't see) in a configuration file. You can think of Rules like code unit tests, but for configuration.

## Installation
Copper is available as a Ruby gem. We recommend installing Copper using Rubygems.

To install Copper, use the following command:

<kbd>
$ gem install copper
</kbd>

You should now be able to run <kbd>$ copper version</kbd> successfully.

## Copper DSL

To define the rules, Copper uses a simple DLS. The Copper DSL looks like Javascript and is very easy to use. The Copper DSL has specific built-in features that are useful in writing rules for Kubernetes configuration files.

Rules are stored in files and each file can contain one of many rules. You can run a rule file against a configuration file using Copper CLI.

## Writing your first rule file

Open up your favorite text editor and enter the following text into a new file called `my_rule.cop`:

<pre class="prettyprint linenums">
rule ApiV1Only ensure {
	fetch("$.apiVersion").first == "v1" // we only allow the use of v1 API functions
}
</pre>

### Let's break this down

**Line 1**: Define a rule called `ApiV1Only`. We want to make sure this rule is always applied and the validation fails if the rule is broken, we we make the rule an `ensure` one.

**Line 2**: We use the `fetch` function to get the value of a node in the configuration file. `fetch` always returns an array of all found matches so we use `.first` to get the first one and compare it with `"v1"` string.

## Validate with your first rule

Now that you have the rule to check for the API version, let's have a look at the configuration file. If you have a Kubernetes configuration file, you can use this rule against that (as all Kubernetes configuration files have the `apiVersion` attribute). Here is an example you can use:

<pre class="prettyprint">
apiVersion: v1
kind: Service
metadata:
  namespace: foobar
  name: foo-svc
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8090
</pre>

Let's save this file as `service.yml` and validate it.

### Using Copper CLI

With your rule `my_rule.cop` and configuration file `service.yml` at hand, hit the Copper CLI:

<kbd>
$ copper check --rules my_rule.cop --file service.yml
</kbd>

You should now see something like this (without the line numbers):

<pre class="prettyprint linenums">
Validating part 0
    ApiV1Only - PASS
</pre>

**Line 1**: Copper CLI can read multi-part YAML files, separated by `---`. `Validating part 0` means Copper is now validating the first part of the YAML configuration file. As our configuration file only has 1 part, we are only going to see `Validation part 0`.

**Line 2**: This line shows that rule `ApiV1Only` has passed the validation successfully.

#### Now let's break the test
As with all good unit tests, you need make sure they work by breaking them!

<pre class="prettyprint">
apiVersion: extensions/v1beta1
kind: Service
...
</pre>

Now let's run the validation again:

<pre class="prettyprint">
Validating part 0
    ApiV1Only - FAIL
</pre>

### Taking it one step further
Now let's allow both `v1 and `extensions/v1beta` values as `apiVersion` in our configuration files, but nothing more:

<pre class="prettyprint linenums">
rule ApiV1Only ensure {
	fetch("$.apiVersion").first == "v1" or // both v1
	fetch("$.apiVersion").first == "extensions/v1beta1" // and v1beta are allowed
}
</pre>

Easy!

## Congratulations!
You successfully wrote your first Copper rule and validated a Kubernetes configuration file! Now let's explore the <a href="/docs/copper-dsl">power of Copper DSL</a>.
