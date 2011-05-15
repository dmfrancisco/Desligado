App.Controllers.Items = Backbone.Controller.extend({
    routes: {
        "":          "index",
        "items/:id": "edit",
        "new":       "create",
        "items/:id/delete": "destroy",
    },

    // Show a list of items
    index: function() {
        var items = new App.Collections.Items();
        items.fetch({
            success: function() {
                new App.Views.Index({ collection: items });
            },
            error: function() {
                new Error({ message: "Error loading items." });
            }
        });
    },

    // Edits a specific item
    edit: function(id) {
        var item = new Item({ id: id });
        item.fetch({
            success: function(model, resp) {
                new App.Views.Edit({ model: item });
            },
            error: function() {
                new Error({ message: 'Could not find that item.' });
                window.location.hash = '#';
            }
        });
    },

    // Shows a blank item ready to be created
    create: function() {
        new App.Views.Edit({ model: new Item() });
    },

    // Delete an item (named 'destroy' instead of 'delete' because safari was complaining about it)
    destroy: function(id) {
        var item = new Item({ id: id });
        item.destroy({
            success: function(model, response) {
                new App.Views.Notice({ message: 'Action completed successfully.' });
                window.location.hash = '#';
            }
        });
    }
});
