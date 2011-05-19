var auto_sync = false;

$(function() {
    if (typeof Faye == 'undefined') {
      console.log("Faye is unavailable, websockets won't be used");
    } else {
        var faye = new Faye.Client('http://localhost:9292/faye');
        auto_sync = true;
        faye.subscribe('/sync', function(data) {
            if (data === 'ping') {
                db.save(function() {
                    var items = new App.Collections.Items();
                    items.fetch({
                        success: function() {
                            // If user is seeing the index page, update it
                            if (window.location.hash === getRoute('index'))
                                new App.Views.Index({ collection: items });
                        },
                        error: function() {
                            new Error({ message: "Error loading items." });
                        }
                    });
                });
            }
        });
    }
});
