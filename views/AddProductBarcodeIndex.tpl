<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>添加商品条码信息</title>
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
            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: left;" onclick="history.back()">
                <img src="/images/back.png" style="margin-top: 10px;height: 25px;cursor: pointer;">
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-md-lg-6" style="text-align: center;color: white; font-size: 22px;margin-top: 8px;">
              添加商品条码信息
            </div>

            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: right;">
            </div>
          </div>
      </nav>


    <div role="main" class="main">

      <div class="container" id="container" style="margin-top:60px;padding-left:0px;padding-right:5px;">
        <div class="row">
          <div class="col-xs-2 col-sm-1 col-md-1 col-md-lg-1">
            <label for="exampleInputEmail1" style="padding-top: 6px; font-size: 16px; color: rgba(0,0,0,0.4);">条码：</label>
          </div>
          <div class="col-xs-10 col-sm-11 col-md-11 col-md-lg-11">
            <input type="text" class="form-control" id="inputID" placeholder="">
          </div>
        </div>
        <div class="row" style="margin-top: 15px;">
          <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
            <label for="exampleInputEmail1" style="padding-top: 6px; font-size: 16px; color: rgba(0,0,0,0.4);">关键字：</label>
          </div>
          <div class="col-xs-8 col-sm-8 col-md-8 col-md-lg-8">
            <input type="text" class="form-control" id="inputKeyword" placeholder="" value="带鱼">
          </div>

          <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3">
                <button type="button" class="btn btn-success btn-md" style="width:100%;" onclick="searchKeyword()">搜索</button>
          </div>


        </div>
        <div class="row">
          <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12" style="margin-top:20px;">

              <div class="list-group" style="text-align:center;" id="listProductNames">
<!--                 <a href="#" class="list-group-item">Dapibus ac facilisis in</a>
                <a href="#" class="list-group-item active">Morbi leo risus</a>
                <a href="#" class="list-group-item">Porta ac consectetur ac</a>
                <a href="#" class="list-group-item">Vestibulum at eros</a>
 -->              </div>
          </div>
        </div>
      </div>
      <nav class="navbar navbar-default navbar-fixed-bottom">
        <div class="container">
          <div class="row">

              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <button type="button" class="btn btn-success" style="width:100%;" onclick="addProductCode()">&nbsp;&nbsp;添 &nbsp; 加&nbsp;&nbsp;</button>

              </div>
          </div>
        </div>
      </nav> 
    <script>
      var Barcode = "{{.Barcode}}";
      $(document).ready(function() {
          prepareBarcodeInput()
          $("#inputID").val(Barcode)
          // console.log($(".list-group-item").length)

          var container = $("#container")
          // return
          // $.get("/MergedOrderDetail?ID=" + orderID, function(orderDetail) {
          //     if(orderDetail == null){
          //       alert("系统出现异常")
          //     }else{
          //       console.log(orderDetail)
          //       _.each(orderDetail.Items, function(_item){
          //         var row = $('<div class = "row" style="border-top: solid 1px rgba(0,0,0,0.1); border-bottom: solid 1px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; font-size: 16px;"> <div class="col-xs-11 col-sm-11 col-md-11 col-md-lg-11" style="text-align: left;"> '+ _item.ProductID +'</div> <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;"> '+ _item.CountNeeded +'</div> </div>')
          //         container.append(row)
          //       })
          //     } 

          // })
      });
      function prepareBarcodeInput(){

        $("#inputID")[0].focus()        
      }
      function searchKeyword() {
        var keyword = $("#inputKeyword").val()
        if(keyword.length > 0){
          $("#listProductNames").empty()
          $.get("/SearchProductByKeyword?ID="+keyword, function(data){
            if(data == null){
              console.log("没有信息返回")
            }else{
              console.log(data)
              var list = $("#listProductNames")
              _.each(data, function(_name){
                var listItem = $('<a href="#" class="list-group-item">'+ _name +'</a>')
                list.append(listItem)
              })
              //添加点击事件
              $(".list-group-item").click(function(){
                $(".list-group-item").removeClass("active")
                $(this).addClass("active")
              })
            }
          })
        }
      }

      function addProductCode() {
          // console.log($(".active").length)
          var productID = $("#inputID").val()
          var name = $(".active").text()
          console.log("商品名称："+name + "  ID: " + productID)
          if(productID.length <= 0 || name.length <= 0){
            return
          }
          $.get("/AddProduct?ID=" + productID + "&name=" + name, function(data) {
              console.log(data)
              if (data.Code == 0) {
                  alert("添加成功")
              } else {
                  alert(data.Message)
              }
          })
      }
    </script>
  </body>
</html>
