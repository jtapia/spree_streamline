//= require admin/spree_backend

(function($) {

  $(document).ready(function(){
    $("#transfer_variant").on("change", function() {
      var stock;
      alert(">>>>>>>>>");
      stock = /\((\d+)\)/.exec($("#s2id_transfer_variant").text())[1];
      return $("#stock").val(stock);
    });
  });

})(jQuery);