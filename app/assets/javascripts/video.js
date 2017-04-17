function video(){
  if($(".video").length <= 0)
    return;
  jwplayer.key="nWN+D87YaKXxihWbtL316egGubuntsJbRAgpFA==";

  if($(".player_qq").length > 0){
      var ww = $(".player_qq")[0].clientWidth;
      $("iframe").width(ww);
      $("iframe").height(ww*0.5625);
  }

  if($(".player_yk").length > 0){
    ykjsapi();
    $(".player_yk").each(function(e){
      var id = $(this).attr('id');
      var vid = $(this).attr('data-vid');
      setTimeout("new JWP({client_id: '82ca06da2497bd12', vid: '" + vid + "',target: 'xxx'}).selectH5MP4()", 200*e);
    });
  }

  if($(".player_163").length >0){
    $(".player_163").each(function(){
      var id = $(this).attr('id');
      var src = $(this).attr('data-src');
      var ww = document.getElementById(id).clientWidth;
      var hh = ww*0.5625;
      var tt = 'mp4';
      var jwp = jwplayer(id)
        jwp.setup({
          file:src,
          type:tt,
          height: hh,
          width: ww,
          players:[
          {type: "flash", src: "/jwplayer.flash.swf"},
          {type: 'html5'}
          ],
        });
    });
  }
  
  // set jwplayer
  window.set_jwplayer = function(src, vid){
    var a = $("div[data-vid='"+vid+"']");
    var id = a.attr('id');
    var ww = document.getElementById(id).clientWidth;
    var hh = ww*0.5625;
    var tt = 'mp4';
    if(src.indexOf('/flv/') > 0)
      tt = 'flv';
    if(tt == 'flv')
      src += src + '.flv'
    var jwp = jwplayer(id)
      jwp.setup({
        file:src,
        type:tt,
        height: hh,
        width: ww,
        flashplayer: '/jwplayer.flash.swf',
        players:[
        {type: "flash", src: "/jwplayer.flash.swf"},
        {type: 'html5'}
        ],
      });
    jwp.on('error',function(e){
      if(e.message == 'Error loading media: File could not be played'){
        $('#'+window.TTID).append("<div class='hidden'><iframe src='http://www.youku.com'></iframe></div>");
        $('div.jw-title-primary.jw-reset').html("服务器开小差了，请刷新页面试一试~");
      }
    });
  }
  
}
