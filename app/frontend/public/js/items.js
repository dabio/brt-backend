$(function () {

  var type      = $('.items').attr('id'),
      api_url   = '/api/' + type,
      admin_url = '/admin/' + type;

  var Item = Backbone.Model.extend({});

  var ItemList = Backbone.Collection.extend({
    model: Item,
    url: api_url
  });

  var Items = new ItemList();

  var ItemView = Backbone.View.extend({
    tagName: 'tr',

    template: _.template($('#template').html()),

    events: {
      'click':          'showDetail',
      'click .remove':  'clear',
      'mouseover':      'showRemove',
      'mouseout':       'hideRemove'
    },

    initialize: function (model) {
      _.bindAll(this, 'render', 'clear');
      this.model.bind('change', this.render, this);
      this.model.bind('destroy', this.remove, this);
    },

    render: function () {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    },

    showDetail: function (e) {
      router.navigate('/'+this.model.get('id'), { trigger: true });
    },

    showRemove: function () {
      this.$('.remove').show();
    },

    hideRemove: function () {
      this.$('.remove').hide();
    },

    clear: function () {
      var item = this;

      if (confirm('Wirklich löschen?')) {
        this.model.destroy();
      }

    }
  });

  var ItemsView = Backbone.View.extend({
    el: $('.items'),

    initialize: function () {
      _.bindAll(this, 'addAll', 'render');
      Items.bind('reset', this.addAll);
      Items.bind('all', this.render);

      Items.fetch();
    },

    render: function () {},

    addOne: function (item) {
      var view = new ItemView({model: item});
      this.$('table tbody').prepend(view.render().el);
    },

    addAll: function () {
      Items.each(this.addOne);
    }

  });

  var Router = Backbone.Router.extend({
    routes: {
      '':     'list',
      ':id':  'detail'
    },

    list: function () {
      var itemsApp = new ItemsView();
    },

    detail: function (id) {
      console.log(id)
    }
  });

  var router = new Router();

  Backbone.history.start({
    pushState: true,
    root: admin_url + '/'
  });

});
