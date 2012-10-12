$(function () {

  window.App = {

  };

  var type      = $('.items').attr('id'),
      admin_url = '/admin/' + type,
      api_url   = '/api/' + type;


  App.Model.Item = Backbone.Model.extend({
    urlRoot: api_url
  });


  .App.Collection.Item = Backbone.Collection.extend({
    model: App.Model.Item,
    url: api_url
  });
  var itemCollection = new ItemCollection();


  var ListView = Backbone.View.extend({

    el: $('.items'),

    initialize: function () {
      _.bindAll(this, 'render');
      itemCollection.on('reset', this.addAll, this);
      itemCollection.on('all', this.render, this);

      itemCollection.reset(window.items);
    },

    render: function () {
      return this;
    },

    addOne: function (item) {
      var view = new ListItemView({model: item});
      this.$('table tbody').prepend(view.render().el);
    },

    addAll: function () {
      itemCollection.each(this.addOne);
    }

  });


  var ListItemView = Backbone.View.extend({

    tagName: 'tr',

    template: _.template($('#item_template').html()),

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


  var Router = Backbone.Router.extend({

    routes: {
      ''    : 'list',
      ':id' : 'edit'
    },

    list: function () {
      if (!this.listView) {
        this.listView = new ListView();
      }
      $('#main').html(this.listView.el);
    },

    edit: function (id) {
      var item = new Item({id: id});

      item.fetch({success: function () {
        $('#main').html(new ItemView({model: item}).el);
      }});
    }

  });


  var router = new Router();


  Backbone.history.start({
    pushState: true,
    root: admin_url + '/'
  });

});
