function set_cookie(name, value){
  var exp = new Date();
  exp.setTime(exp.getTime() + 60*60*1000);
  document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString() +";";
}
function get_cookie(name){
  var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
  if(arr=document.cookie.match(reg))
    return unescape(arr[2]);
  else
    return null;
}
function google_chaping_ads(){
  var show_ads = get_cookie("google_ads_showed");
  if(show_ads == null){
    if($("#chaping_ad").length > 0){
      set_cookie("google_ads_showed", 1);
      Turbolinks.visit("/app/ad_google");
    }
  }
}
