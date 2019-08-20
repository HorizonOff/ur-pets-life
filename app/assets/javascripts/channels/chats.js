$( document ).on('turbolinks:load', function() {
  if ($('#messages').length > 0) {
    var $element = $('[data-channel-subscribe="room"]'),
    messageTemplate = $('[data-role="message-template"]');
    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)
    App.messages = App.cable.subscriptions.create({
      channel: 'ChatMessagesChannel',
      chat_id: $('#messages').data('support-chat-id') }, {
      // Called when there's incoming data
      //on the websocket for this channel.
      received: function(data) {
        console.log(data.chat_message.text);
        var content = messageTemplate.children().clone(true, true);
        content.find('.message-content').addClass(data.chat_message.m_type);
        content.find('[data-role="message-text"]').text(data.chat_message.text);
        content.find('[data-role="message-date"]').text(new Date(data.chat_message.created_at));
        $element.append(content);
        $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);
      },
    });
  };
})
