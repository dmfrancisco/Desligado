var Item = Backbone.Model.extend({
    // Models are populated by json data
    url: function() {
        var base = 'items';
        // Since this is RESTful model, it should POST to /items for a CREATE action
        if (this.isNew()) return base;
        // If it's not new, then it should POST to /documents/id for an UPDATE action
        return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id;
    },
    sync: hybridSync
    // localStorage: new Store("pendingItems")
});
