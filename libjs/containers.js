function Containers(containers) {
    this.containers = containers
}

Containers.prototype.by_name = function(name) {
    for (var c in this.containers) {
        var item = this.containers[c];
        if (item.name === name) {
            return item
        }
    }

    return null
};
