function DockerImage (source_image) {
    var full_image = source_image.trim();
    var full_name = '';
    if (!full_image.includes('/')) {
        full_name = "library/" + full_image;
    }
    if (!full_image.includes('/')) {
        full_image = "library/" + full_image;
    }
    if (!full_image.includes(":")) {
        full_image = full_image + ":latest";
    }
    var proto = 'https://';
    if (/^https/.test(full_image)) {
        proto = 'https://';
        full_image = full_image.replace(/https:\/\//, '');
    }
    else if (/^http/.test(full_image)) {
        full_image = full_image.replace(/http:\/\//, '');
    }
    // trim / from front and back
    full_image = full_image.replace(/^\//, '').replace(/\/$/, '');
    var registry
    // figure out registry
    if (/^library\//.test(full_image) || full_image.split('/').length < 3) {
        // its docker io
        registry = 'index.docker.io';
    }
    else {
        registry = full_image.replace(/\/.*/, '');
    }
    // figure out image name
    full_image = full_image.replace(/#{registry}(\/(v|V)(1|2)|)/i, '').replace(/^\//, '').replace(/\/$/, '');
    var image_parts = full_image.split(':');
    var image_name = image_parts[0];
    var image_tag = image_parts[1];
    // recombine for registry
    var registry_url = proto + registry;
    var fqin = registry_url + "/" + full_image;
    this.fqin = fqin;
    this.registry = registry;
    this.registry_url = registry_url;
    this.name = image_name;
    this.tag = image_tag;
}

DockerImage.prototype.address = function() {
    return this.registry + this.name + ":" + this.tag
};
