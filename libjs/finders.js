// finds the deployment that's used for a service given it's labels and service's selectors
function findDeploymentForService(list, selectors) {
    return findByLabels(list, "Deployment", selectors);
}

function replaceResource(list, resource) {
    replaceItem(list, resource.kind, resource.metadata.name, resource);
}

// replaces an item of the given kind and name with a replacement
function replaceItem(list, kind, name, replacement) {
    for (var index = 0; index < list.length; index++) {
        var element = list[index];

        if ((element.kind === kind) && (element.metadata.name === name)) {
            // found it.
            list[index] = replacement;
            return
        }
    }
}

function findByName(list, kind, name) {
    var found;
    list.forEach(function(resource) {
        if ((resource.kind === kind) && (resource.metadata.name === name)) {
            found = resource;
            return;
        }
    });

    return found;
}

// finds an item using the labels and its kind
function findByLabels(list, kind, labels) {
    var found;
    list.forEach(function(element) {
        if (element.kind === kind) {
            if (doLabelsMatch(element, labels)) {
                found = element;
                return;
            }
        }
    });

    return found;
}

// checks it two sets of labels (and selectors) match
function doLabelsMatch(item, labels) {
    itemLabels = getLabels(item);
    for (label in labels) {
        if (labels[label] != itemLabels[label]) {
            return false;
        }
    }

    return true;
}

function getLabels(item) {
    return item.spec.template.metadata.labels;
}

function deepCompare () {
    var i, l, leftChain, rightChain;

    function compare2Objects (x, y) {
        var p;

        // remember that NaN === NaN returns false
        // and isNaN(undefined) returns true
        if (isNaN(x) && isNaN(y) && typeof x === 'number' && typeof y === 'number') {
            return true;
        }

        // Compare primitives and functions.
        // Check if both arguments link to the same object.
        // Especially useful on the step where we compare prototypes
        if (x === y) {
            return true;
        }

        // Works in case when functions are created in constructor.
        // Comparing dates is a common scenario. Another built-ins?
        // We can even handle functions passed across iframes
        if ((typeof x === 'function' && typeof y === 'function') ||
            (x instanceof Date && y instanceof Date) ||
            (x instanceof RegExp && y instanceof RegExp) ||
            (x instanceof String && y instanceof String) ||
            (x instanceof Number && y instanceof Number)) {
            return x.toString() === y.toString();
        }

        // At last checking prototypes as good as we can
        if (!(x instanceof Object && y instanceof Object)) {
            return false;
        }

        if (x.isPrototypeOf(y) || y.isPrototypeOf(x)) {
            return false;
        }

        if (x.constructor !== y.constructor) {
            return false;
        }

        if (x.prototype !== y.prototype) {
            return false;
        }

        // Check for infinitive linking loops
        if (leftChain.indexOf(x) > -1 || rightChain.indexOf(y) > -1) {
            return false;
        }

        // Quick checking of one object being a subset of another.
        // todo: cache the structure of arguments[0] for performance
        for (p in y) {
            if (y.hasOwnProperty(p) !== x.hasOwnProperty(p)) {
                return false;
            }
            else if (typeof y[p] !== typeof x[p]) {
                return false;
            }
        }

        for (p in x) {
            if (y.hasOwnProperty(p) !== x.hasOwnProperty(p)) {
                return false;
            }
            else if (typeof y[p] !== typeof x[p]) {
                return false;
            }

            switch (typeof (x[p])) {
                case 'object':
                case 'function':

                    leftChain.push(x);
                    rightChain.push(y);

                    if (!compare2Objects (x[p], y[p])) {
                        return false;
                    }

                    leftChain.pop();
                    rightChain.pop();
                    break;

                default:
                    if (x[p] !== y[p]) {
                        return false;
                    }
                    break;
            }
        }

        return true;
    }

    if (arguments.length < 1) {
        return true; //Die silently? Don't know how to handle such case, please help...
        // throw "Need two or more arguments to compare";
    }

    for (i = 1, l = arguments.length; i < l; i++) {

        leftChain = []; //Todo: this can be cached
        rightChain = [];

        if (!compare2Objects(arguments[0], arguments[i])) {
            return false;
        }
    }

    return true;
}
