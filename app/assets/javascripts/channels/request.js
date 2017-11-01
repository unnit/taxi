$(document).ready(function(){
  App.taxi = App.cable.subscriptions.create({channel: "RequestChannel"},
  {
    received: function(data) {
      if(data['waiting_partial']){
        var waiting = $(data['waiting_partial']).hide();
        $(".waiting-req-wrapper").prepend(waiting);
        $(".waiting-"+data['request_id']).find(".j-accept-link").attr("href", "/requests/"+data['request_id']+"/accept?driver_id="+$(".waiting-req-wrapper").attr("data-driver-id"));
        if($(".ongoing-req-wrapper").children().length > 0){$(".j-accept-link").hide();}
        $(".waiting-"+data['request_id']).fadeIn();
      }
      else if(data['ongoing_partial']){
        $(".waiting-req-wrapper").find(".waiting-"+data['request_id']).remove();
        $(".j-accept-link").hide();
        var ongoing = $(data['ongoing_partial']).hide();
        $(".ongoing-driver-"+data['driver_id']).prepend(ongoing);
        $(".ongoing-"+data['request_id']).fadeIn();
        $(".flash-messages").html(data['msg']);
        setTimeout(function(){$(".flash-messages").html("");}, 10000);
      }
      else if(data['completed_partial']){
        $(".ongoing-req-wrapper").find(".ongoing-"+data['request_id']).remove();
        $(".j-accept-link").show();
        var completed = $(data['completed_partial']).hide();
        $(".completed-driver-"+data['driver_id']).prepend(completed);
        $(".completed-"+data['request_id']).fadeIn();
        $(".flash-messages").html(data['msg']);
        setTimeout(function(){$(".flash-messages").html("");}, 10000);
      }
    }
  });
});
