function purchase_in_app(){
  if($('#pia').length <= 0){
    return;
  }
  if($("input[type='radio']:checked").length == 0){
    alert("xx");
    return;
  }
  var ios_product_id = $("input[type='radio']:checked").val();
  window.webkit.messageHandlers.NativeApp.postMessage({func: "do_purchase", message: "购买流量包", ios_product_id: ios_product_id}); 
}
