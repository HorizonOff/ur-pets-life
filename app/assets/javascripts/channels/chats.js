
// $(document).ready(function() {
//   App.chat = App.cable.subscriptions.create(
//     {
//         channel: "ChatMessageChannel",
//         chat_id: 3
//     },
//     {

//     // Called when the subscription is
//     // ready for use on the server.
//     connected: function() {
//       console.log("Connected to Chat Channel");
//     },

//     // Called when the subscription has
//     // been terminated by the server.
//     disconnected: function() {
//       console.log("Disconnected from the Chat Channel");
//     },

//     // Called when there's incoming data
//     //on the websocket for this channel.
//     received: function(data) {
//       console.log(data);
//     },
//   });
// });


this.App = {};

App.cable = ActionCable.createConsumer();


App.messages = App.cable.subscriptions.create({ channel: 'ChatMessagesChannel', chat_id: '3' } , {
  // Called when the subscription is
  // ready for use on the server.
  connected: function() {
    console.log("Connected to Chat Channel");
  },

  // Called when the subscription has
  // been terminated by the server.
  disconnected: function() {
    console.log("Disconnected from the Chat Channel");
  },

  // Called when there's incoming data
  //on the websocket for this channel.
  received: function(data) {
    console.log(data);
  },
});
