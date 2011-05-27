App.Collections.Items = Backbone.Collection.extend({
    model: Item,
    url: '/items',
    sync: hybridSync
    // localStorage: new Store("pendingItems")
});
