function populate(combined_value){
  var array = combined_value.split("|");
  var product_id = array[0];
  var description = array[1];
  var price = array[2];
  var user_id = array[3];
  var product_name = array[4];

  var title_element = document.getElementById('purchase_option');
  title_element.innerHTML = description.concat(" $").concat(price);
  var amount_element = document.getElementById('purchase_amount');
  amount_element.value = price;
  var purchase_custom = document.getElementById('purchase_custom');
  purchase_custom.value = user_id.concat(",").concat(product_id);
  var item_name = document.getElementById('item_name');
  item_name.value = product_name;

  var paypal_btn = document.getElementById('paypal_btn');
  paypal_btn.type = "image";
}
