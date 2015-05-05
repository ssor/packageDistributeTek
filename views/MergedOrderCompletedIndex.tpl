<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>订单详情</title>
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
            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: left;" onclick="history.back()">
                <img src="/images/back.png" style="margin-top: 10px;height: 25px;">
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-md-lg-6" style="text-align: center;color: white; font-size: 22px;margin-top: 8px;">
              订单详情
            </div>

            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: right;">
              <!-- <div style="color: white; font-size: 18px; padding-top: 8px;cursor: pointer;" onclick="submitResult()">完成</div> -->
            </div>
          </div>
      </nav>


    <div role="main" class="main">

      <div class="container" id="container" style="margin-top:60px;padding-left:0px;padding-right:5px;">
      </div>

    <script>
      var orderID = "{{.OrderID}}";

      $(document).ready(function() { 

          var container = $("#container")
          // return
          $.get("/MergedOrderDetail?ID=" + orderID, function(orderDetail) {
              if(orderDetail == null){
                alert("系统出现异常")
              }else{
                console.info("从服务器获得合并订单数据")
                console.log(orderDetail)

                _.each(orderDetail.Items, function(_item){
                    var row = $('<div class = "row itemUnactive" style="border-top: solid 1px rgba(0,0,0,0.1); border-bottom: solid 1px rgba(0,0,0,0.1); padding-top: 10px; padding-bottom: 10px; font-size: 16px;"> <div class="col-xs-11 col-sm-11 col-md-11 col-md-lg-11" style="text-align: left;"> '+ _item.ProductID +'</div> <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1" style="text-align: right;"> '+ _item.CountNeeded +'</div> </div>')
                    container.append(row)
                })
              } 

          })
      });

    </script>
  </body>
</html>
