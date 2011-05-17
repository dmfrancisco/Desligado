App.Views.Show = Backbone.View.extend({
    initialize: function() {
        this.render();
    },

    render: function() {
        $(this.el).html(JST.show({ model: this.model }));
        $('#app').html(this.el);
    }
});
