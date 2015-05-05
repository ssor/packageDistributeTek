<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>集合单拣选</title>
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
            <div class="col-xs-5 col-sm-5 col-md-5 col-md-lg-5" style="text-align: left;left;cursor:pointer;" onclick="window.location.href='/'">
               <img src="/images/logo_pure.png" class="img-responsive" alt="Responsive image" style="width: 35px; margin-top: 6px;float: left;margin-right: 10px;">
               <div style="color: rgba(256,256,256,1); padding-top: 10px; font-size: 18px; margin-left: -50px;">订单拣选系统</div>
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-md-lg-6" style="text-align: center;color: white; font-size: 22px;margin-top: 8px;">
              
            </div>

            <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;">
              <div style="color: white; font-size: 18px; padding-top: 8px;cursor: pointer;" onclick="submitResult()">完成</div>
            </div>
          </div>
      </nav>


      <div class="container" style="margin-top:60px;">
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: right;">
                <button id="btnChangeInputSource" type="button" class="btn btn-default btn-small" onclick="changeInputSource()" style="margin-top: 4px; color: rgba(0,0,0,0.5);padding-top: 2px; padding-bottom: 2px;">手动输入 </button>
          </div>
          <div class="col-xs-8 col-sm-8 col-md-8 col-md-lg-8" style="text-align: center;">
              <input type="text" class="form-control" id="inputID" placeholder="" value="" style="text-align: center;margin-bottom: 0px;"> </div>
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: left;">
                <button id="btnSubmitBarcode" type="button" class="btn btn-success btn-small" onclick="submitBarcode()" style="margin-top: 4px;padding-top: 2px; padding-bottom: 2px;">&nbsp;&nbsp;提交&nbsp;&nbsp; </button>
          </div>
      </div>
      <div class="container" id="container" style="margin-top:20px;padding-left:0px;padding-right:5px;">
            <!-- <input type="text" class="form-control" id="inputID" placeholder="" value="" style="text-align: center;margin-bottom: 20px;"> -->
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
      var orderID = "{{.OrderID}}";
      var orderDetail_temp = null
      var tempInput = ""
      var ScanInput = 0//扫描输入
      var ManualInput = 1//手动输入
      var inputSource = ScanInput
      var container
      $(document).ready(function() { 

          if(window.localStorage){
           // alert('This browser supports localStorage');
             prepareData()
          }else{
             alert('浏览器不支持本地存储，系统功能可能不正常');
          }

          prepareBarcodeInput()
          $("#btnSubmitBarcode").hide()

          container = $("#container")
          // return
          $.get("/MergedOrderDetail?ID=" + orderID, function(orderDetail) {
              if(orderDetail == null){
                alert("系统出现异常")
              }else{
                console.info("从服务器获得合并订单数据")
                console.log(orderDetail)
                  orderDetail_temp = orderDetail
                //检查是否第一次拣选该合并项，如果是，保存到数据库；如果不是，使用历史数据
                // if(orderDetail_temp == null){
                //   orderDetail_temp = orderDetail
                //   saveData()
                // }else if(orderDetail_temp.ID == orderDetail.ID){
                //   console.info("使用从数据库获取的本地数据")
                //   orderDetail = orderDetail_temp
                // }
                _.each(orderDetail.Items, function(_item, index){
                  var row = $('<div class = "row itemActive" style="border-top: solid 1px rgba(0,0,0,0.1); border-bottom: solid 1px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; font-size: 16px;" > <div class="col-xs-11 col-sm-11 col-md-11 col-md-lg-11" style="text-align: left;"> '+ _item.ProductID +'</div> <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;"> '+ _item.CountNeeded +'</div> </div>')
                  // if(_item.CurrentCount == _item.CountNeeded){
                  //   row = $('<div class = "row itemUnactive" style="border-top: solid 1px rgba(0,0,0,0.1); border-bottom: solid 1px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; font-size: 16px;"> <div class="col-xs-11 col-sm-11 col-md-11 col-md-lg-11" style="text-align: left;"> '+ _item.ProductID +'</div> <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;"> '+ _item.CountNeeded +'</div> </div>')
                  // }
                  if(index <= 0){
                    row.css("font-size", "36px")
                  }
                row.click(function() {
                    var name = $($(this).children()[0]).text()
                    var r = confirm("您将要将 【"+ name +"】 设为拣选完成状态，确定吗？")
                    if (r == true) {
                        $(this).removeClass("itemActive").addClass("itemUnactive")
                        updateSequence(name)
                    }
                })
                  container.append(row)
                })
              } 

          })
          setInterval(submitOrder, 200)

      });
      function prepareBarcodeInput(){
        $("#inputID").focus(function(){
            HideAlertMessage()
          // $("#blurAlert").hide()
        });
        $("#inputID").blur(function(){
          ShowAlertMessage("警告：页面已经失去焦点，扫描的条码失效")
          // $("#blurAlert").show()
        });

        $("#inputID")[0].focus()        
      }

      function submitResult() {
          if (orderDetail_temp == null) return
          var itemsUncompleted = _.reject(orderDetail_temp.Items, function(_item) {
              return _item.CountNeeded == _item.CurrentCount
          })
          if (_.size(itemsUncompleted) > 0) {
              var r = confirm("该集合单将被设置为件选完成状态，确定吗？")
              if (r == false) {
                  return
              }
          }
          $.get("/SetMergedOrderCompleted?ID=" + orderID, function(cmd) {
              console.log(cmd)
              if(cmd.Code == 0){
                alert("设置成功")
                window.opener=null;
                window.open('','_self');
                window.close();
              }else{
                alert(cmd.Message)
              }
          })
      }
      function saveData(){
        localStorage.orderDetail = JSON.stringify(orderDetail_temp)
      }
      function prepareData(){
        if(localStorage.orderDetail != null){
          orderDetail_temp = JSON.parse(localStorage.orderDetail)
          console.info("数据库恢复成功")
          console.log(orderDetail_temp)
        }
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
      //有新拣选项目更新时，保存到数据库
      function updatePickupResult(completedProductName){
        if(orderDetail_temp == null) return
        var item = _.findWhere(orderDetail_temp.Items, {ProductID: completedProductName})
        if(item == null){
          console.log("系统出错")
          ShowAlertMessage("集合单中不需要该商品")
        }else{
          item.CurrentCount = item.CountNeeded//需求量和拣选量一致，表明拣选完成
          // saveData()
          console.info("%s 拣选完成，结果保存到本地数据库", completedProductName)
        }
      }
      function openAddOrderIndex() {
          window.open("/AddOrderIndex")
      }
      function ShowAlertMessage(msg){
          $("#blurAlert").text(msg).show()
      }
      function HideAlertMessage(){
          $("#blurAlert").hide()
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
      function request(id){
          if(id.length <= 0) return
          HideAlertMessage()
          $.get("/GetProductInfo?ID=" + id, function(data) {
              console.log(data)
              if(data==null){
                ShowAlertMessage("系统中不存在该产品信息")
                // console.info("获取不到产品信息，即将转向商品信息添加页面")
                // window.location.href= "/AddProductBarcodeIndex?ID="+ id;
              }else{
                updatePickupResult(data.Name)
                updateSequence(data.Name)

              }
          })      
      }
      function submitBarcode(){
          var newInput = $("#inputID").val()
          if(newInput.length > 0){
            request(newInput)
            $("#inputID").val("")
          }
      }
       //重新排序，将未完成的向上提
      function updateSequence(name) {
          var items = $('.itemActive')
          console.log("找到了 %d 个列表项", items.length)
          _.each(items, function(_item) {
              var $item = $(_item)
              var $firstChildren = $($item.children()[0])
              var content = $firstChildren.text()
                  // console.log(content)
              if (content.trim() == name) {
                  console.info("找到了")
                  $item.removeClass("itemActive").addClass("itemUnactive")
              }
          })

          var activeItems = $('.itemActive')
          if (_.size(activeItems) > 0) {
              $(activeItems[0]).css("font-size", "36px")
          }
          var unactiveItems = $('.itemUnactive')
          _.each(unactiveItems, function(item) {
              $(item).css("font-size", "16px")
          })
          container.empty()
          container.append(activeItems)
          _.each(activeItems, function(item) {
              $(item).click(function() {
                  var name = $($(this).children()[0]).text()
                  var r = confirm("您将要将 【" + name + "】 设为拣选完成状态，确定吗？")
                  if (r == true) {
                      $(this).removeClass("itemActive").addClass("itemUnactive")
                      updateSequence(name)
                  }
              })
          })
          container.append(unactiveItems)
      }
    </script>
  </body>
</html>