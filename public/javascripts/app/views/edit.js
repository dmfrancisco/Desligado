App.Views.Edit = Backbone.View.extend({
    events: {
        "submit form": "save"
    },

    initialize: function() {
        _.bindAll(this, 'render');
        this.model.bind('change', this.render);
        this.render();
    },

    save: function() {
        var self = this;
        var msg = this.model.isNew() ? 'Successfully created!' : "Saved!";

        this.model.save({ name: this.$('[name=name]').val(), category: this.$('[name=category]').val() }, {
            success: function(model, resp) {
                new App.Views.Notice({ message: msg });
                Backbone.history.saveLocation('items/' + model.id);
            },
            error: function() {
                new App.Views.Error({ message: 'Error saving this item. Did you filled all attributes?' });
            }
        });

        return false;
    },

    render: function() {
        $(this.el).html(JST.edit({ model: this.model }));
        $('#app').html(this.el);

        // use val to fill in name, for security reasons
        this.$('[name=name]').val(this.model.get('name'));

        this.delegateEvents();
    }
});
