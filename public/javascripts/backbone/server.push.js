$(function() {
    var synced = false;
    var faye = new Faye.Client('http://localhost:9292/faye');

    faye.subscribe('/sync', function(data) {
        if (synced) {
            synced = false;
        } else if (data === 'ping') {
            save(function() {
                synced = true;

                var items = new App.Collections.Items();
                items.fetch({
                    success: function() {
                        // If user is seeing the index page, update it
                        if (window.location.pathname.slice(0, -1) === getRoute('index'))
                            new App.Views.Index({ collection: items });
                    },
                    error: function() {
                        new Error({ message: "Error loading items." });
                    }
                });
            });
        }
    });
});
