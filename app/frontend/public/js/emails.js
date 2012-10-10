$(function () {

  var Email = Backbone.Model.extend({
  });

  var EmailList = Backbone.Collection.extend({
    model: Email,
    url: '/api/emails'
  });
  var Emails = new EmailList();

  var EmailView = Backbone.View.extend({
    tagName: 'tr',

    template: _.template($('#email-template').html()),

    events: {},

    initialize: function (model) {
      _.bindAll(this, 'render', 'clear');
      this.model.bind('change', this.render, this);
    },

    render: function () {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    },

    clear: function () {
      this.model.destroy();
    }
  });

  var EmailsAppView = Backbone.View.extend({
    el: $('#emails'),

    initialize: function () {
      _.bindAll(this, 'addAll', 'render');
      Emails.bind('reset', this.addAll);
      Emails.bind('all', this.render);

      Emails.fetch();
    },

    render: function () {},

    addOne: function (email) {
      var view = new EmailView({model: email});
      this.$('table tbody').prepend(view.render().el);
    },

    addAll: function () {
      Emails.each(this.addOne);
    },

  });

  var EmailsApp = new EmailsAppView();
});
