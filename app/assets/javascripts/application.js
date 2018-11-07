// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require turbolinks
//= require_tree .

$(document).on("turbolinks:load", function(){
  if($("img.lazy").length > 0){
    $("img.lazy").lazyload({threshold: 200, effect: "fadeIn"});
  }
  pinglun();
  $("#ad_1").click(function(){
    $(this).attr("href","/yys/card/104");
  });
  $("#ad_2").click(function(){
    $(this).attr("href","/yys/card/104");
  });
  if($("#need_taobao_convert_url").length > 0){
    taodianjin(window,document);
  }
  if($(".video").length > 0){
    video();
  }
  if($("#article_list").length > 0){
    $(window).on("scroll", function(){
      var more_products_url = $('.pagination a[rel=next]').attr('href');
      if(more_products_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60){
        $('.pagination').html('');
        $.ajax({
          url: more_products_url,
          success: function(data){
            $("#article_list").append(data);
            $('img.lazy[src=""]').lazyload({threshold: 200, effect: "fadeIn"});
          }

        });
      }
      if(!more_products_url){
        $('.pagination').html('');
      }
    });
  }
  if($("#video_list").length > 0){
    $(window).on("scroll", function(){
      var more_products_url = $('.pagination a[rel=next]').attr('href');
      if(more_products_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60){
        $('.pagination').html('');
        $.ajax({
          url: more_products_url,
          success: function(data){
            $("#video_list").append(data);
            $('img.lazy[src=""]').lazyload({threshold: 200, effect: "fadeIn"});
            $('img.lazy[src="/default.jpeg"]').lazyload({threshold: 200, effect: "fadeIn"});
          }

        });
      }
      if(!more_products_url){
        $('.pagination').html('');
      }
    });
  }
  if($("#search_fuli").length > 0){
    $("#search_fuli").on('keypress', function(e){
      var _this = $("#search_fuli");
      if(e.keyCode == 13 && $.trim(_this.val()) != ''){
        Turbolinks.visit("/app/sale_search/" + encodeURIComponent($.trim(_this.val())));
      }
    });
  }
  if($("#search_qq_video").length > 0){
    $("#search_qq_video").on('keypress', function(e){
      var _this = $("#search_qq_video");
      if(e.keyCode == 13 && $.trim(_this.val()) != ''){
        Turbolinks.visit("/wzry/qq_video_search/" + encodeURIComponent($.trim(_this.val())));
      }
    });
  }
});

var do_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  $.ajax({
    url: "/search/app",
    type: "post",
    dataType: "json",
    data: {
      'keyword': k,
    },
    beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
    success: function(data){
      if(data.code == 1){
        Turbolinks.visit("/app/tag/" + data.tag + "/");
      }
      else{
        $("#message").html("哎呀 未找到...");
        $("#message").removeClass("hide");
      }
    }
  })
};

var yys_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  Turbolinks.visit("/yys/ali_search/" + encodeURI(k) + "/?isFirst=0");
};
var mrzh_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  Turbolinks.visit("/mrzh/ali_search/" + encodeURI(k) + "/?isFirst=0");
};

var wzry_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  Turbolinks.visit("/wzry/ali_search/" + encodeURI(k) + "/?isFirst=0");
};

var qjnn_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  Turbolinks.visit("/qjnn/ali_search/" + encodeURI(k) + "/?isFirst=0");
};

var hszz_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  $.ajax({
    url: "/hszz/search",
    type: "post",
    dataType: "json",
    data: {
      'keyword': k,
    },
    beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
    success: function(data){
      if(data.code == 1){
        Turbolinks.visit("/hszz/tag/" + data.tag + "/");
      }
      else{
        $("#message").html("哎呀 未找到...");
        $("#message").removeClass("hide");
      }
    }
  })
};

var lzg_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  Turbolinks.visit("/lzg/search/" + encodeURIComponent(k.trim()));
};

var gmdl_search = function(){
  var k = $("#keyword").val();
  if(k.trim() == ''){
    return;
  }
  Turbolinks.visit("/gmdl/search/" + encodeURIComponent(k.trim()));
};
