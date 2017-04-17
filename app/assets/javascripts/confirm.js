function pinglun(){
  if($('#pinglun_ad').length <= 0){
    return;
  }
  var a = confirm("亲，给个五星好评，即可解锁全部功能哦!");
  if(a == true){
    window.webkit.messageHandlers.NativeApp.postMessage({func: "jump_pinglun", message: "成功"})
  }
}

function shengqian(){
  if($('#shengqian_ad').length <= 0){
    return;
  }
  var a = confirm("100元天猫内部现金券，快来领取吧");
  if(a == true){
    window.webkit.messageHandlers.NativeApp.postMessage({func: "jump_shengqian", message: "成功", url: "https://itunes.apple.com/app/apple-store/id1116025300?pt=118055102&ct=wzrycs&mt=8"})
  }
}
