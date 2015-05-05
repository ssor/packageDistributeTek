<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>集合单拣选列表</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="icon" 
          type="image/png" 
          href="/images/logo_pure.png">
    <!--[if lte IE 8]><link rel="stylesheet" href="../../responsive-nav.css"><![endif]-->
    <!--[if gt IE 8]><!--><!--<![endif]-->
<!--     <link rel="stylesheet" type="text/css" href="/easyUI/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="/easyUI/themes/icon.css">
 -->    
    <link href="/bootstrap/css/bootstrap.css" rel="stylesheet" media="screen">    
    <link href="/dataTable/css/jquery.dataTables.css" rel="stylesheet" media="screen">    
    <style type="text/css">
      td.highlight {
          background-color: rgba(0,256,0, 0.1) !important;
      }
      tr.highlight{
          background-color: rgba(0,256,0, 0.1) !important;
      }
      #dtProcess{
        text-align: center;
      }
      th{
        text-align: center;
      }
      .title{
        font-size: 32px;
        font-weight: 800;
        margin-bottom: 10px;
      }
    </style>

    <script src="/javascripts/jquery.min.js" type="text/javascript"></script> 
    <script src="/bootstrap/js/bootstrap.min.js"></script>
    <script src="/dataTable/js/jquery.dataTables.js"></script>
    <script src="/javascripts/underscore.js" type="text/javascript"></script>  
  </head>
  <body>

      <nav class="navbar navbar-default navbar-fixed-top" style="text-align: center;background-color: rgba(0,128,0,0.8);">
        <div class="container">
          <div class="row" id = "subNavBar" style="">
            <div class="col-xs-5 col-sm-5 col-md-5 col-md-lg-5" style="text-align: left;cursor:pointer;" onclick="window.location.href='/'">
                <img src="/images/logo_pure.png" class="img-responsive" alt="Responsive image" style="width: 35px; margin-top: 6px;float: left;margin-right: 10px;">
                <div style="color: rgba(256,256,256,1); padding-top: 10px; font-size: 18px; margin-left: -50px;">订单拣选系统</div>
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-md-lg-6" style=""> <!-- 选择拣选项目 --> </div>

            <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;">
                <img src="/images/refresh.png" style="margin-top: 10px;height: 25px;cursor: pointer;" onclick="reloadFromServer()">
            </div>

          </div>
      </nav>


    <div role="main" class="main">
      <div class="container" style="margin-top:60px;">
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: left;"></div>
          <div class="col-xs-8 col-sm-8 col-md-8 col-md-lg-8" style="text-align: center;">
              <input type="text" class="form-control" id="inputID" placeholder="" value="" style="text-align: center;margin-bottom: 20px;"> </div>
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: left;"></div>
      </div>

      <div class="container" id="container" style="margin-top:0px;padding-left:0px;padding-right:0px;">
        
      </div>
      <nav class="navbar navbar-default navbar-fixed-bottom">
        <div class="container">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div id="blurAlert" class="alert alert-danger" role="alert" style="text-align: center;"></div>
              </div>
        </div>
      </nav>       
    <script>
      // var orders = [{ID: "12345", Over: true},{ID: "12346", Over: false},{ID: "12347", Over: true}]
      var tempInput = ""
      var orders = null
      var container 

      $(document).ready(function() {
          container = $("#container")
          reloadFromServer()
          prepareBarcodeInput()
          setInterval(submitOrder, 200)

          // var button1 = $('<button type="button" class="btn btn-default btn-lg btn-block" style="background-color: rgba(0,0,0,0.1); color: rgba(0,0,0,0.6);">（块级元素）1</button>')
          // container.append(button1)
      });

      function reloadFromServer() {
          console.info("更新订单信息")

          $.get("/MergedOrders", function(_orders) {
              console.log(_orders)
              orders = _orders
              reloadFromLocalData(orders)
          })        
      }
      function reloadFromLocalData(orders){
          container.empty()
              var ordersCompleted = _.filter(orders, function(_order) {
                  return _order.Over == true
              })
              _.each(ordersCompleted, function(_order) {
                  var button1 = $('<button type="button" onclick="openMergedOrderCompletedIndex('+ _order.ID +')"  class="btn btn-default btn-lg btn-block" style="background-color: rgba(0,0,0,0.2); color: rgba(0,0,0,0.6);" id="' + _order.ID + '">' + _order.ID + '</button>')
                  container.append(button1)
              })
              var ordersUncompleted = _.filter(orders, function(_order) {
                  return _order.Over == false
              })
              _.each(ordersUncompleted, function(_order) {
                  var button1 = $('<button type="button" onclick="openPickUpMergedOrderIndex('+ _order.ID +')" class="btn btn-default btn-lg btn-block" style="" id="' + _order.ID + '">' + _order.ID + '</button>')
                  container.append(button1)
              })          
      }
      function prepareBarcodeInput(){
        $("#inputID").focus(function(){
            HideAlertMessage()
        });
        $("#inputID").blur(function(){
          ShowAlertMessage("警告：页面已经失去焦点，扫描的条码失效")
        });

        $("#inputID")[0].focus()        
      }      
      function ShowAlertMessage(msg){
          $("#blurAlert").text(msg).show()
      }
      function HideAlertMessage(){
          $("#blurAlert").hide()
      }      
      function openAddProductBarcodeIndex() {
          window.location.href= "/AddProductBarcodeIndex";
      }

      function openPickUpMergedOrderIndex(id) {
          window.location.href= "/PickUpMergedOrderIndex?ID="+id;
      }
      function openMergedOrderCompletedIndex(id) {
          window.location.href= "/MergedOrderCompletedIndex?ID="+id;
      }
      //检查是否有条码录入，如果有，发起查询请求
      function submitOrder() {
          //条码枪没有后缀的解决方案
          var newInput = $("#inputID").val()
              // if(newInput.length > 0){
              //   console.log("新输入值：" + newInput)
              // }
          if (newInput.length > 0) {
              if (newInput == tempInput) {
                  console.info("输入值确定为：" + newInput)
                  tempInput = ""
                  $("#inputID").val("")
                  reloadFromLocalData(orders)//刷新之前可能高亮的选项
                  request(newInput)
              } else {
                  tempInput = newInput
              }
          }
      }        
      function request(id) {
          if (id.length <= 0) return

          $.get("/GetMergeOrderInfoByOrderID?orderID=" + id, function(data) {
              console.log(data)
              if (data == null) {
                  console.error("系统异常")
              } else {
                if(data.Code == 0){
                  if(data.Data == null){
                    console.warn("系统异常")
                  }else{
                    var mergedOrderID = data.Data.ID
                    var button = $("#"+mergedOrderID)
                    if(button != null){
                      button.removeClass("btn-default").addClass("btn-success")
                    }
                  }
                  HideAlertMessage()
                }else{
                  ShowAlertMessage(data.Message)
                }
              }
          })
      }      
    </script>
  </body>
</html>
