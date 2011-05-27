var auto_sync = false;
var synced = false;

// Sync DB and render the view with the new data
function syncAndRender() {
    db.save(function() {
        synced = true;
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

$(function() {
    if (typeof Faye == 'undefined') {
        console.log("Faye is unavailable, websockets won't be used. Using timer instead.");
        window.setInterval(function() { // Timer instead
            syncAndRender();
        }, 5000); // 5 seconds

    // Using websockets with faye
    } else {
        var faye = new Faye.Client('http://localhost:9292/faye');
        auto_sync = true;
        faye.subscribe('/sync', function(data) {
            if (synced)
                synced = false;
            else if (data === 'ping') {
                synced = true;
                syncAndRender();
            }
        });
    }
});
