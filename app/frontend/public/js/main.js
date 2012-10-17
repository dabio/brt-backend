Backbone.View.prototype.close = function() {
  $(this.el).empty();//.detach();
  this.remove();
  this.unbind();
  this.onClose && this.onClose();
  app.log('View: close');
};


window.app = {

  debug: true,
  type: $('.items').attr('id'),
  adminUrl: function () {
    return '/admin/' + this.type;
  },

  apiUrl: function () {
    return '/api/' + this.type;
  },

  collections:  {},
  models:       {},
  views:        {},

  initialize: function() {

    app.router = new app.Router();

    Backbone.history.start({
      pushState: true,
      root: this.adminUrl() + '/'
    });

  },

  log: function(str) {
    this.debug && console.log(str);
  }

};


$(function () {
  app.initialize();
});


app.Router = Backbone.Router.extend({

  el: $('#main'),

  routes: {
    ''    : 'list',
    ':id' : 'edit'
  },

  list: function () {
    this.renderView(
      new app.views.Items()
    );
  },

  edit: function (id) {
    this.renderView(
      new app.views.Edit({ id: id })
    );
  },

  renderView: function (view) {
    app.log('Router: renderView');
    if (this.currentView) {
      app.log('Router: closeView');
      this.currentView.close();
    }

    this.currentView = view;
    this.currentView.render();

    this.el.html(this.currentView.el);
  }

});


app.models.Item = Backbone.Model.extend({
  urlRoot: app.apiUrl()
});


app.collections.Items = Backbone.Collection.extend({
  model: app.models.Item,
  url: app.apiUrl(),
});
app.collections.items = new app.collections.Items();


app.views.Items = Backbone.View.extend({

  tagName: 'table',
  className: 'width-100 striped',

  initialize: function () {
    app.log('View: init items');
    _.bindAll(this, 'render', 'addOne', 'addAll');

    app.collections.items.on('add', this.addOne, this);
    app.collections.items.on('reset', this.addAll, this);
    app.collections.items.fetch();
    //app.collections.items.on('all', this.render, this);
  },

  addOne: function (item) {
    var view = new app.views.Item({model: item});
    this.$el.append(view.render().el);
  },

  addAll: function () {
    app.collections.items.each(this.addOne);
  },

  onClose: function() {
    app.collections.items.off();
  }

});


app.views.Item = Backbone.View.extend({

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
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  showDetail: function (e) {
    app.router.navigate('/' + this.model.get('id'), { trigger: true });
  },

  showRemove: function () {
    this.$('.remove').css('visibility', 'visible');
  },

  hideRemove: function () {
    this.$('.remove').css('visibility', 'hidden');
  },

  clear: function (e) {
    e && e.preventDefault();

    if (confirm('Wirklich löschen?')) {
      this.model.destroy();
      this.remove();
    }
  },

  onClose: function () {
    this.model.off();
  }

});


app.views.Edit = Backbone.View.extend({

  el: $('.edit'),

  template: _.template($('#edit_template').html()),

  initialize: function (options) {
    app.log('View: init edit');
    _.bindAll(this, 'render');

    this.model = new app.models.Item({ id: options.id })
    this.model.on('all', this.addOne, this);
    this.model.fetch();
  },

  addOne: function () {
    $(this.el).html(this.template(this.model.toJSON()));
  },

  render: function () {
    app.log('View: render edit');
    return this;
  },

  onClose: function () {
    this.model.off();
  }

});
