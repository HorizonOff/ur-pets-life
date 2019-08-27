$( document ).on('turbolinks:load', function() {
  if ($('#messages').length > 0) {
    $('[data-channel-subscribe="room"]').each(function(index, element) {
      var $element = $(element),
      messageTemplate = $('[data-role="message-template"]');
      var height = $element[0].scrollHeight;
      $element.scrollTop(height);
      // var objDiv = document.getElementById("messages");
      // objDiv.scrollTop = objDiv.scrollHeight;
      // $('#messages').stop().animate({
      //   scrollTop: $('#messages')[0].scrollHeight - $('#messages')[0].clientHeight
      // }, 800);
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
          content.find('[data-role="message-date"]').text(data.chat_message.timestamp);
          if (data.chat_message.photo.url) {
            content.find('[data-role="message-img"]').attr("src", data.chat_message.photo.url);
            content.find('[data-role="message-video"]').addClass('display-none');
          } else if (data.chat_message.video.url) {
            content.find('[data-role="message-video"]').attr("src", data.chat_message.video.url);
            content.find('[data-role="message-video"]').attr("controls", 'controls');
            content.find('[data-role="message-img"]').addClass('display-none');
          } else {
            content.find('[data-role="message-video"]').addClass('display-none');
            content.find('[data-role="message-img"]').addClass('display-none');
          }
          if (data.chat_message.m_type == 'system') {
            $('#chat-form').addClass('display-none');
            $('.close-chat').addClass('display-none');
          }
          $('#messages-pool').append(content);
          var height = $element[0].scrollHeight;
          $element.scrollTop(height);
          $('#new_chat_message').find('input[type="text"]').val('');
          $('#new_chat_message').find('input[type="file"]').val('');
        },
      });
    });
  };
})
