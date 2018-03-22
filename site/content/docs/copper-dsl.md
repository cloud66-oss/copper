+++
title = "Copper DSL"
description = "Using Copper DSL for configuration validations"
date = 2018-03-19T10:59:22Z
weight = 20
draft = false
bref = "Using Copper DSL for configuration validations"
toc = true
+++

## Basics

Copper DSL is a simple language that's focused on fetching values from configuration files and checking their validity. It has built-in functionality to deal with IP Addresses, Semantic versioning of components and basic string manipulation.

### Copper files
Copper files contain the Copper DSL script. They have text files and have a `.cop` extension. You can use any text editor to edit them.

<div class="message focus" data-component="message">
<h5>Copper Syntax Highlighting</h5>
<p>There is an <a href="https://marketplace.visualstudio.com/items?itemName=cloud66.copper">extension for VisualStudio Code</a> that provides syntax highlighting for Copper files. This extension is under active development and doesn't support Copper DSL's full syntax.</p>
</div>

### Rules
A rule is like a test you would like to run against your configuration file. Just like code unit tests, it's better to keep the rules focused on one specific area of the configuration file and give then relevant names. A Copper file can contain as many rules as you like.

#### Name
A rule must have a name. Names should begin with a letter and can contain any alphanumerical characters.

#### Action
A rule must have an Action. Action is what should happen if the rule fails: An `ensure` action means failure of the rule will fail the validation. A `warn` action means a warning is shown next to the failed rule but the validations will pass.

#### Condition
A condition is a boolean logic that should be true for the rule to pass.

#### Syntax

<pre class="prettyprint">
rule NAME (warn | ensure) {
	CONDITION
}
</pre>

**Example**
<pre class="prettyprint">
rule foo ensure {
	1 = 1
}
</pre>

<p class="small">
Defines a rule called <code>foo</code> which ensures the statement <code>1 = 1</code> returns <code>true</code>
</p>

### Variables
You can define variables in Copper files as a way to avoid repeating the same things over and over again. For example, you can keep your the valid range of ports in a variable and use that variable in different rules. In Copper DSL, variables are more like constants in other languages and cannot be changed once set.

#### Syntax
<pre class="prettyprint">
var VARIABLE = VALUE
</pre>

**Example**
<pre class="prettyprint">
var foo = 1
var bar = "hello"
var valid_ports = (8000..9000)
</pre>

**Using variables in a rule**
<pre class="prettyprint">
rule bar warn {
	8050 in valid_ports == true
}
</pre>

### Comments
Copper files can be commented. Copper supports the Java comment syntax:

<pre class="prettyprint">
rule foo warn { // this is a single inline comment
	1 = 1 /* this is a single line block comment */
}

/* we are going to comment this part off
rule bar ensure {
	false = true
}*/
</pre>

### Comparisons
The condition inside of a rule is usually made up of a value compared against another value. The result of this comparison is either true or false.

The comparison operation can be one of the following:

<table class="striped">
	<tr><th>Operation</th><th>Meaning</th></tr>
	<tr><td><code>=</code> or <code>==</code></td><td>Left side is equal the right side</td></tr>
	<tr><td><code>></code></td><td>Left side is greater than the right side</td></tr>
	<tr><td><code><</code></td><td>Left side is less than the right side</td></tr>
	<tr><td><code>>=</code></td><td>Left side is greater than or equal the right side</td></tr>
	<tr><td><code><=</code></td><td>Left side is less than or equal the right side</td></tr>
	<tr><td><code>!=</code></td><td>Left side is not equal the right side</td></tr>
	<tr><td><code>in</code></td><td>Right side is included in the left side (only for sets and ranges)</td></tr>
</table>

### Condition logic
Comparisons can be combined with `and` and `or` to make up more complex conditions.

**Example**
<pre class="prettyprint">
rule ComplexRulesAreUs warn {
	2 > 1 and 3 == 3 or 2 != 8 and
	8 in [1,2,3,4]
}
</pre>

<table class="striped">
	<tr><th>Boolean Operand</th><th>Meaning</th></tr>
	<tr><td><code>and</code>, <code>&</code> or <code>&&</code></td><td>Boolean AND</td></tr>
	<tr><td><code>or</code>, <code>|</code> or <code>||</code></td><td>Boolean OR</td></tr>
</table>

### Base Data types
Copper DSL supports the following data types:

#### Number
A number is integer or decimal.

**Example**
<pre class="prettyprint">
var my_int = 12
rule foo ensure {
	my_int > 11.43
}
</pre>

#### String
Strings are wrapped in double quotes `"`.

**Example**
<pre class="prettyprint">
var a_string = "foo"
</pre>

Strings have the following attributes:

<h5><span class="code-attribute">count</span></h5>

Returns the length of the string: `"foo".count` will return 3.

<h5><span class="code-attribute">gsub</span></h5>

Replaces text in the string using the regular expression pattern given.

For example `"abc".gsub("b", "!")` will return `"a!c"`.

<h5><span class="code-attribute">at</span></h5>

Returns the character at the given index: `"abc".at(2)` returns `"b"`.

<h5><span class="code-attribute">split</span></h5>

Splits the string into an array: `"foo/bar/baz".split("/")` returns `["foo", "bar", "baz"]`.

#### Array
Arrays can contain any number of values. Arrays can hold values of different types. An array is wrapped in `[` and `]` and each item is separated by a `,`.

**Example**
<pre class="prettyprint">
var my_array = [1,2,3,4]
</pre>

Arrays have the following attributes:

<h5><span class="code-attribute">count</span></h5>

Returns the number of items in the array: `[1,2,3].count` will return 3.

<h5><span class="code-attribute">first</span></h5>

Returns the first item of the array: `["foo","bar",45].first` will return `"foo"`.

<h5><span class="code-attribute">last</span></h5>

Returns the last item of the array: `["foo","bar",45].first` will return 45.

<h5><span class="code-attribute">at</span></h5>

Returns the item at the given index: `[1, "item 2", "third item", 4].at(2)` returns `"item 2"`.

<h5><span class="code-attribute">contains</span></h5>

Returns true if the given item can be found in the array: `[1,2,"foo"].contains(2)` will return true.

<h5><span class="code-attribute">unique</span></h5>

Removes duplicates from the array and returns a new array: `[1,2,3,2,1].unique` will return `[1,2,3]`

<h5><span class="code-attribute">extract</span></h5>

Runs each item of a string only array through a regular expression and returns the item with the given index of the regexp:

`["name1:tag1", "name2:tag2", "name3:tag3"].extract(".*:(.*)", 1)` will return `["tag1", "tag2", "tag3"]`. The number `1` in this case refers to the regexp group.

**Another example**

`["path1/image1:tag1", "path2/image2:tag2"].extract(".*\/(.*):.*", 2)` will return `["image1", "image2", "image3"]`.


<h5><span class="code-attribute">as</span></h5>

Converts each element of an array into a different data type. For example this can be used to convert an array of strings into Image data type.

`["quay.io/mysql:1.2.3", "ubuntu:3.2.1"].as(:image)` returns an array of `Image` data type (see below).

<h5><span class="code-attribute">pick</span></h5>

Returns an array by picking an attributes off of each item of the array. For example this can be used to pick the `tag` attribute of an array of `Image`.

The example below returns the length of each element of an array:

`["a", "xo", "foo"].pick(:count)` returns `[1, 2, 3]`

`pick` takes in the name of the attribute to pick in the form of a `:` followed by the attribute name. For example to pick the `tag` attribute you can use `pick(:tag)`.

##### Equality

You can use `=` or `==` to compare two arrays. This will return true if both arrays contain the same items but ignores the ordering of the items. For example:

`[1,2,3] == [2,3,1]` while `[1,2,3] != [1,2,3,4]`.

##### Inclusion

You can use the `in` comparison for arrays: `1 in [1,2,3]` is true and `"foo" in ["bar", "fuzz"]` is false.

#### Range

Range contains all the numbers between two numbers. Ranges are wrapped in `(` and `)` with `..` between the low and the high numbers. Range is inclusive of both ends.

**Example**
<pre class="prettyprint">
var the_range = (1..10)
</pre>

<h5><span class="code-attribute">contains</span></h5>

Returns true if the given item can be found in the range: `(1..10).contains(1)` will return true.

##### Inclusion

You can use the `in` comparison for ranges: `10 in (1..10)` is true and `13 in (23..45)` is false.


### Complex data types

Copper DSL supports a growing set of configuration specific data types. Currently this includes the following:

#### IPAddress

An IPAddress can hold an IP address and/or subnet. You can use IPAddress to check various things about an IPAddress, like it's range, inclusion of other IP addresses, its class and more.

**Example**
<pre class="prettyprint">
var internal = ipaddress("62.0.0.0/24")
var front_end = ipaddress("62.0.2.45")
</pre>

IPAddress has the following attributes:

<h5><span class="code-attribute">first</span></h5>

Returns the first IP address in a range: `ipaddress("10.0.0.0/24").first` will return `ipaddress("10.0.0.1")`

<h5><span class="code-attribute">last</span></h5>

Returns the last IP address in a range: `ipaddress("10.0.0.0/24").last` will return `ipaddress("10.0.0.254")`

<h5><span class="code-attribute">full_address</span></h5>

Returns the IP address and the prefix: `ipaddress("10.0.0.1").full_address` will return `"10.0.0.1/32"`

<h5><span class="code-attribute">address</span></h5>

Returns the IP address without the prefix: `ipaddress("172.16.10.1/24").address` will return `"172.16.10.1"`

<h5><span class="code-attribute">netmask</span></h5>

Returns the IP netmask: `ipaddress("10.0.0.0/8").netmask` will return `"255.0.0.0"`

<h5><span class="code-attribute">octets</span></h5>

Returns an array of IP address octets: `ipaddress("172.16.10.1").octets` will return `[172, 16, 10, 1]`

<h5><span class="code-attribute">prefix</span></h5>

Returns the IP address prefix without the address: `ipaddress("172.16.10.1/24").prefix` will return `8`

<h5><span class="code-attribute">is_network</span></h5>

Returns true if the given IP address is a network address. `ipaddress("10.0.0.0/24").is_network` will return true while `ipaddress("10.0.0.1/32").is_network` returns false.

<h5><span class="code-attribute">is_loopback</span></h5>

Returns true if the given IP address is a local loopback address. `ipaddress("127.0.0.1").is_loopback` will return true.

<h5><span class="code-attribute">is_multicast</span></h5>

Returns true if the given IP address is a multicast address. `ipaddress("224.0.0.1/32").is_multicast` will return true.

<h5><span class="code-attribute">is_class_a</span></h5>

Returns true if the given IP address is a class A IP address. `ipaddress("10.0.0.1/24").is_class_a` will return true.

##### Inclusion
Inclusion of an IP address in a network IP range can be checked using the `in` comparison. For example `ipaddress("10.1.1.32") in ipaddress("10.1.1.0/24")` returns true.

<h5><span class="code-attribute">is_class_b</span></h5>

Returns true if the given IP address is a class A IP address. `ipaddress("172.16.10.1/24").is_class_b` will return true.

<h5><span class="code-attribute">is_class_c</span></h5>

Returns true if the given IP address is a class A IP address. `ipaddress("192.168.1.1/30").is_class_c` will return true.

#### Semver
Semver holds and parses a string as a [Semantic version](https://semver.org/). This allows support of semantic versioning and checks.

**Example**
<pre class="prettyprint">
var mysql_version = semver("6.5.0")
var web_server = semver("1.2.4-pre")
</pre>

<h5><span class="code-attribute">major</span></h5>

Returns the major part of the version number: `semver("6.5.7").major` returns `"6"`.

<h5><span class="code-attribute">minor</span></h5>

Returns the minor part of the version number: `semver("6.5.7").major` returns `"5"`.

<h5><span class="code-attribute">patch</span></h5>

Returns the patch part of the version number: `semver("6.5.7").major` returns `"7"`.

<h5><span class="code-attribute">build</span></h5>

Returns the build part of the version number if available: `semver("3.7.9-pre.1+revision.15723").major` returns `"revision.15623"`.

<h5><span class="code-attribute">pre</span></h5>

Returns the pre part of the version number if available: `semver("3.7.9-pre.1+revision.15723").major` returns `"pre.1"`.

<h5><span class="code-attribute">satisfies</span></h5>

Checks if a semver satisfies a Pessimistic version comparison: `semver("1.6.5").satisfies("~> 1.5")` returns true.

##### Comparison

You can use `<`, `>`, `=`, `==`, `<=`, `>=` and `!=` comparisons between two semvers.

#### Image
Image holds a Docker image path and lets you access its different parts. It also understands some of the particular attributes of docker images (like no registry name means DockerHub or no tag means latest).

For example, you can parse a string containing an image name to an `Image` like this:

`var i = image("quay.io/cloud66/mysql:5.6.1")` this will let you access the image name constituents:

`i.registry` or `i.tag`. The `Image` type, combined with `as` and `pick` will make a powerful tool for inspecting images used in a configuration file.

<h5><span class="code-attribute">registry</span></h5>

Returns the registry name of the image. It will return `index.docker.io` if no registry is available in the image name.

<h5><span class="code-attribute">name</span></h5>

Returns the name of the image. It will append `library/` to the beginning of the image name if no namespace is available on the image name (DockerHub image names). For example, `ubuntu:1.2.3` will return `library/ubuntu` as `name`.

<h5><span class="code-attribute">tag</span></h5>

Returns the tag of the image. It will return `latest` if no tag is available on the image. For example `mysql` will return `latest` as the `tag`.

<h5><span class="code-attribute">registry_url</span></h5>

Returns the URL for the registry, including the scheme. For example, `quay.io/ubuntu:1.2.3` returns `https://quay.io` as `registry_url`.

<h5><span class="code-attribute">fqin</span></h5>

Returns the Fully Qualified Image Name. This includes the scheme. For example `ubuntu` will return `https://index.docker.io/library/ubuntu:latest`.

### Type conversion and parsing
In most cases, values read from a configuration file are strings. In order for them to be usable with Copper DSL's complex data types, you can read them as different types using the `as` function.

`As` function takes in a type name which is a `:` followed by the type name. For example to convert a string into a `Semver` use `:semver` in the `as` function: `"1.2.3".as(:semver)`

**Example**
<p class="small">
Here, we are assuming the value of the `mysql_version` variable is a string `"5.6.7"`:
</p>

<pre class="prettyprint">
mysql_version.as(:semver).satisfies("~> 5.6")
</pre>

### Accessing configuration filename

The full name of the configuration file used in a check is available in the Copper DSL as `filename`. `filename` is a `Filename` data type with the following attributes:

<h5><span class="code-attribute">path</span></h5>

Returns the path to the configuration file (excluding the filename). For example `samples/test.yml` returns `samples`.

<h5><span class="code-attribute">name</span></h5>

Returns the filename of the configuration file (excluding the path). For example `samples/test.yml` returns `test`.

<h5><span class="code-attribute">ext</span></h5>

Returns the file extension of the configuration file (including the leading `.`). For example `samples/test.yml` returns `.yml`.


<h5><span class="code-attribute">full_name</span></h5>

Returns the full filename of the configuration file. For example `samples/test.yml` returns `samples/test.yml`.

<h5><span class="code-attribute">expanded_path</span></h5>

Returns the full expanded file path of the configuration file. For example `samples/test.yml` will return (depending on the absolute location of the file) something like `/Users/john/projects/tests/kubernetes/samples/test.yml`.

### Reading from configuration files
Copper DSL uses [JSONPath](http://goessner.net/articles/JsonPath/) format to read values from a configuration file. For any configuration file format, the content is first read and converted in to JSON which makes it possible to use JSONPath to find nodes and attributes in the configuration file.

The `fetch` function accepts the JSONPath and returns an array of all matching nodes and attributes in the configuration.

<p class="small">This is a YAML configuration file used in the following examples</p>

<pre class="prettyprint">
apiVersion: v1
kind: Service
metadata:
  namespace: foobar
  name: foo-svc
  annotations:
    cloud66.com/snapshot-uid: 123-456-789
    cloud66.com/snapshot-gitref: abcd
  labels:
    app: foo
    tier: bar
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8090
  - port: 8100
    targetPort: 8100
  - port: 5000
  selector:
    app: foo
    tier: bar
</pre>

To fetch the value of `type` under `spec` (which is `NodePort` in the file above), we can use the following JSONPath format:

<pre class="prettyprint">
fetch("$.spec.type") // will return ["NodePort"]
</pre>

To return all the `targetPort` values under `spec.port` you can use attribute selectors:

<pre class="prettyprint">
fetch("$.spec.ports..targetPort") // will return [8090, 8100]
</pre>

To return the value of `targetPort` for the `8080` port (`8090` in the example above) you can use the filters:

<pre class="prettyprint">
fetch("$.spect.ports[?(@.port == 8080)]") // will return [8090]
</pre>

#### JSONPath syntax

You can use the [JSONPath reference](http://goessner.net/articles/JsonPath/) as a syntax guideline. Copper DSL implements a subset of JSONPath, listed below. You can also use the [Online JSONPath](http://jsonpath.com/) evaluator for testing or refer to the debugging section below:

<table class="striped">
	<tr><th>Operation</th><th>Meaning</th></tr>
	<tr><td><code>$</code></td><td>The root element to query. This starts all path expressions.</td></tr>
	<tr><td><code>@</code></td><td>The current node being processed by a filter predicate.</td></tr>
	<tr><td><code>*</code></td><td>Wildcard. Available anywhere a name or numeric are required.</td></tr>
	<tr><td><code>..</code></td><td>Deep scan. Available anywhere a name is required.</td></tr>
	<tr><td><code>.&lt;name&gt;</code></td><td>Dot-notated child</td></tr>
	<tr><td><code>['&lt;name&gt;' (, '&lt;name&gt;')]<name></code></td><td>Bracket-notated child or children</td></tr>
	<tr><td><code>[&lt;number&gt; (, &lt;number&gt;)]<name></code></td><td>Array index or indexes</td></tr>
	<tr><td><code>[start:end]<name></code></td><td>Array slice operator</td></tr>
	<tr><td><code>[?(&lt;expression&gt;)]&lt;name&gt;</code></td><td>Filter expression. Expression must evaluate to a boolean value.</td></tr>
</table>

<table class="striped">
<tr>
<th>Operator</th>
<th>Description</th>
</tr>
<tr>
<td><code>==</code></td>
<td>left is equal to right (note that 1 is not equal to '1')</td>
</tr>
<tr>
<td><code>!=</code></td>
<td>left is not equal to right</td>
</tr>
<tr>
<td><code>&lt;</code></td>
<td>left is less than right</td>
</tr>
<tr>
<td><code>&lt;=</code></td>
<td>left is less or equal to right</td>
</tr>
<tr>
<td><code>&gt;</code></td>
<td>left is greater than right</td>
</tr>
<tr>
<td><code>&gt;=</code></td>
<td>left is greater than or equal to right</td>
</tr>
</table>

**Another example**

<pre class="prettyprint">
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  namespace: foobar
  name: foo
spec:
  template:
    metadata:
      labels:
        app: foo
        tier: bar
    spec:
      containers:
        - name: foo
          image: index.docker.io/library/ubuntu:latest
          ports:
            - containerPort: 8080
        - name: mysql
          image: quay.io/mysql:2.3.0
          ports:
            - containerPort: 3306
        - name: buzz
          image: quay.io/pg:latest
          ports:
            - containerPort: 8080
      imagePullSecrets:
      - name: registry-pull-secret
</pre>

<div>
	<p class="small">Get the image tag of all containers</p>
	<pre class="prettyprint">
fetch("$.spec.spec.containers..image").extract(".*:(.*)", 1) // returns ["latest", "2.3.0", "latest"]
</pre>
	<p class="small">Get the image name of the container named <code>mysql</code></p>
	<pre class="prettyprint">
fetch("$.spec.spec.containers[?(@.name == 'mysql')]") // will return ["index.docker.io/library/ubuntu:latest"]
</pre>
</div>

### Debugging

You can dump the results of variables and comparisons to the console using the `-> console` directive.

<div class="message warning" data-component="message">
    <h5>Note</h5>
    For <code>console</code> to work, you need to run Copper CLI with the <code>--debug</code> option.
</div>


<pre class="prettyprint">
$ copper check --rules rule.cop --file config.yml --debug
</pre>

**Example**
<p class="small">
Write the value of variable `mysql_version` to the console
</p>

<pre class="prettyprint">
rule foo warn {
	mysql_variable -> console
}
</pre>

<p class="small">
Write the result of a comparison to the console
</p>

<pre class="prettyprint">
rule foo warn {
	fetch("$.spec.template.images").contain("ubuntu") -> console
}
</pre>

<p class="small">
Write the result of a <code>fetch</code> to console
</p>

<pre class="prettyprint">
rule foo warn {
	fetch("$.spec.ports..targetPort") -> console
}
</pre>
