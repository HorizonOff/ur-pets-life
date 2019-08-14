//= require cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();


App.messages = App.cable.subscriptions.create({ channel: 'ChatMessagesChannel', chat_id: '1' } , {
  received: function(data) {
    $("#messages").removeClass('hidden')
    alert(data.message)
  },

});
