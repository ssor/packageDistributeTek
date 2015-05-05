<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>合并订单</title>
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
      .itemActive{
        background-color: rgba(0,0,0,0.1);
      }
      .itemUnactive{
        background-color: rgba(0,0,0,0);
      }

    </style>

    <script src="/javascripts/jquery.min.js" type="text/javascript"></script> 
    <script src="/bootstrap/js/bootstrap.min.js"></script>
    <script src="/dataTable/js/jquery.dataTables.js"></script>
    <script src="/javascripts/underscore.js" type="text/javascript"></script>  
    <script>

    </script> 
  </head>
  <body >

      <nav class="navbar navbar-default navbar-fixed-top" style="text-align: center;background-color: rgba(0,128,0,0.8);">
        <div class="container">
          <div class="row" id = "subNavBar" style="">
            <div class="col-xs-5 col-sm-5 col-md-5 col-md-lg-5" style="text-align: left;cursor:pointer;" onclick="window.location.href='/'">
                <img src="/images/logo_pure.png" class="img-responsive" alt="Responsive image" style="width: 35px; margin-top: 6px;float: left;margin-right: 10px;">
                <div style="color: rgba(256,256,256,1); padding-top: 10px; font-size: 18px; margin-left: -50px;">订单拣选系统</div>
            </div>
            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: left;">
            </div>
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/PickUpIndex" role="button" style="width: 100%; color: rgba(256,256,256,0.9); padding-top: 10px; font-size: 16px;">拣选</a> -->
              </div>
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/OrderListIndex" role="button" style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">订单管理</a>    -->
              </div>    
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/MergeOrderManagementIndex" role="button" style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">集合单管理</a>    -->
              </div>    

              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <a class="btn btn-link" href="/MergeOrderIndex" role="button" style="width: 100%; color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">新集合单</a>  
              </div>                             

          </div>
      </nav>




<!--       <div class="container" style="margin-top:50px;margin-bottom:10px;">
          <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12" style="text-align: center;font-size: 30px; color: red;" onclick="openAddNewMergeOrderIndex()">+</div>
      </div> -->
      <div class="container" style="margin-top:60px;">
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: right;">
                <button id="btnChangeInputSource" type="button" class="btn btn-default btn-small" onclick="changeInputSource()" style="margin-top: 4px; color: rgba(0,0,0,0.5);padding-top: 2px; padding-bottom: 2px;">手动输入 </button>
          </div>
          <div class="col-xs-8 col-sm-8 col-md-8 col-md-lg-8" style="text-align: center;">
              <input type="text" class="form-control" id="inputID" placeholder="" value="" style="text-align: center;margin-bottom: 20px;"> </div>
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: left;">
                <button id="btnSubmitBarcode" type="button" class="btn btn-success btn-small" onclick="submitBarcode()" style="margin-top: 4px;padding-top: 2px; padding-bottom: 2px;">&nbsp;&nbsp;提交&nbsp;&nbsp; </button>
          </div>
      </div>

      <div class="container" style="margin-top:0px;">
          <div class="row">
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: center;color: rgba(0,0,0,0.4);"></div>
          <div class="col-xs-4 col-sm-4 col-md-4 col-md-lg-4" style="text-align: center;color: rgba(0,0,0,0.4);">集合单总商品量</div>
          <div class="col-xs-4 col-sm-4 col-md-4 col-md-lg-4" style="text-align: center;color: rgba(0,0,0,0.4);">集合单总订单数</div>
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: center;color: rgba(0,0,0,0.4);"></div>
        </div>

          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: center;color: rgba(0,0,0,0.4);"></div>
          <div id="totalCount" class="col-xs-4 col-sm-4 col-md-4 col-md-lg-4" style="text-align: center;font-size: 40px;"> 0</div>
          <div id="totalOrderCount" class="col-xs-4 col-sm-4 col-md-4 col-md-lg-4" style="text-align: center;font-size: 40px;"> 0</div>
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: center;color: rgba(0,0,0,0.4);"></div>
      </div>

      <div class="container" id="container" style="margin-top:0px;padding-left:0px;padding-right:5px;">
<!--           <div class = "row" style="border-top: solid 1px rgba(0,0,0,0.1); border-bottom: solid 1px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; font-size: 16px;">
            <div class="col-xs-11 col-sm-11 col-md-11 col-md-lg-11" style="text-align: left;"> 北海道秋刀鱼500g（3条装）</div>
            <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;"> 10</div>
          </div>
          <div class = "row" style="border-top: solid 1px rgba(0,0,0,0.1); border-bottom: solid 1px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; font-size: 16px;">
            <div class="col-xs-11 col-sm-11 col-md-11 col-md-lg-11" style="text-align: left;"> 北海道秋刀鱼500g（3条装）</div>
            <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;"> 10</div>
          </div>
 -->
      </div>
      <nav class="navbar navbar-default navbar-fixed-bottom">
        <div class="container">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div id="blurAlert" class="alert alert-danger" role="alert" style="text-align: center;"></div>
              </div>
        </div>
      </nav> 
    <script>
      var tempInput = ""
      var mergedOrderID = "{{.mergedOrderID}}"
      var ScanInput = 0//扫描输入
      var ManualInput = 1//手动输入
      var inputSource = ScanInput

      $(document).ready(function() { 

          prepareBarcodeInput()
          $("#btnSubmitBarcode").hide()

          // return
          $.get("/MergedOrderDetail?ID=" + mergedOrderID, function(orderDetail) {
              if(orderDetail == null){
                console.info("系统出现异常")
              }else{
                console.info("从服务器获得合并订单数据")
                console.log(orderDetail)
                refreshOrderListView(orderDetail.OrderIDList)
                updateTotalCount(orderDetail.TotalItemCount, _.size(orderDetail.OrderIDList))

              } 

          })
          setInterval(submitOrder, 200)

      });
      function refreshOrderListView(orderIDList){
          var container = $("#container")
          container.empty()
          _.each(orderIDList, function(_orderID){
            var row = $('<div class = "row itemUnactive" style="border-top: solid 1px rgba(0,0,0,0.1); border-bottom: solid 1px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; font-size: 16px;"> <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12" style="text-align: center;"> '+ _orderID +'</div> </div>')
            container.prepend(row)
            // container.append(row)
          })        
      }
      function prepareBarcodeInput(){
        $("#inputID").focus(function(){
          // $("#blurAlert").hide()
            HideAlertMessage()
        });
        $("#inputID").blur(function(){
          // $("#blurAlert").show()
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
      function changeInputSource(){
        if(inputSource == ScanInput){
          inputSource = ManualInput
          $("#btnChangeInputSource").text("自动输入")
          $("#btnSubmitBarcode").show()

          $("#inputID")[0].focus()        
        }else{
          inputSource = ScanInput
          $("#btnChangeInputSource").text("手动输入")
          $("#btnSubmitBarcode").hide()
          $("#inputID")[0].focus()        
        }
      }      
      function openAddOrderIndex() {
          window.open("/AddOrderIndex")
      }
      function openAddNewMergeOrderIndex(){
        // window.open("/MergeOrderIndex")
        window.location.href = "/MergeOrderIndex"
      }
      //检查是否有条码录入，如果有，发起查询请求
      function submitOrder() {
        if(inputSource == ManualInput){//切换为手动输入状态后，不再自动提交
          return
        }        
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
                  request(newInput)
              } else {
                  tempInput = newInput
              }
          }
      }      
      function updateTotalCount(itemsCount,ordersCount){
        $("#totalCount").text(itemsCount)
        $("#totalOrderCount").text(ordersCount)
      }
      function submitBarcode(){
          var newInput = $("#inputID").val()
          if(newInput.length > 0){
            request(newInput)
            $("#inputID").val("")
          }
      }
      function request(id) {
          if (id.length <= 0) return
          $.get("/MergeOrder?orderID=" + id + "&mergedOrderID=" + mergedOrderID, function(data) {
              console.log(data)
              if (data == null) {
                  console.error("系统异常")
              } else {
                if(data.Code == 0){
                  if(data.Data == null){
                    console.error("系统异常")
                  }else{
                    mergedOrderID = data.Data.ID
                    console.log("集合单 %s 总共需要 %d 个商品", data.Data.ID, data.Data.TotalItemCount)
                    refreshOrderListView(data.Data.OrderIDList)
                    updateTotalCount(data.Data.TotalItemCount, _.size(data.Data.OrderIDList))
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
