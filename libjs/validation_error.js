function ValidationError() {
    this.errors = []
}

ValidationError.prototype.add_error = function(check_name, title, severity) {
    if ((typeof severity === 'number') && (typeof title === 'string') && (typeof check_name === 'string')) {
        this.errors.push({ check_name: check_name, title: title, severity: severity });
    } else {
        throw "invalid title or severity. severity should be a number, title should be a string and check_name should be a string"
    }

    return null
};
