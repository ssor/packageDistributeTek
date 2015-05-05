<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>拣选货位信息</title>
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
            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: left;">
            </div>
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/PickUpIndex" role="button" style="width: 100%; color: rgba(256,256,256,0.9); padding-top: 10px; font-size: 16px;">订单拣选</a> -->
              </div>
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/OrderListIndex" role="button" style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">订单管理</a>    -->
              </div>    
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/MergeOrderManagementIndex" role="button" style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">集合单管理</a>    -->
              </div>    

              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/ProductManagementIndex" role="button" style="width: 100%; color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">产品管理</a>   -->
              </div>                             

          </div>
      </nav>


    <div role="main" class="main">

      <div class="container" style="margin-top:80px;">
          <div class="title" style="">货位拣选详细信息({{.ShelfID}}号拣选墙)</div>
          <p class="intro">查看当前拣选尚未完成的货位的商品需求</p>
          <div class="row" id = "subNavBar" style="">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div style="border-bottom: solid 1px rgba(0,0,0,0.2); margin-bottom: 30px;"></div>
                <button type="button" class="btn btn-default btn-small" onclick="reload()">&nbsp;&nbsp;刷 &nbsp; 新 &nbsp;&nbsp;</button>
                <button type="button" class="btn btn-success btn-small" onclick="clearPos()">强制清空货位</button>
                <button type="button" class="btn btn-success btn-small" onclick="complteOrder()">强制完成拣选中的订单</button>
                <div style="border-bottom: solid 1px rgba(0,0,0,0.1); margin-top: 10px;"></div>
                <table id="dtProcess" class="display" cellspacing="0" width="100%" >
                    <thead>
                        <tr>
                            <th>货位号</th>
                            <th>订单</th>
                            <th>商品名称</th>
                            <th>需求量</th>
                        </tr>
                    </thead>
                </table>
              </div>
          </div>
      </div>
    <script>
      var table;

      $(document).ready(function() {

          table = $('#dtProcess').DataTable({
              "columnDefs": [],
              "paging": false,
              "ordering": true,
              "order": [
                  [0, "asc"]
              ],
              "info": false,
              "searching": true,
              "ajax": {
                  "url": "/GetPositionsNeedDetail?ShelfID={{.ShelfID}}",
                  "dataSrc": ""
              },
              "columns": [
              {
                  "data": "PositionID",
                  "width": "15%"
              }, 
              {
                  "data": "OrderID",
                  "width": "15%"
              }, 

              {
                  "data": "ProductName",
                  "width": "60%"
              }, 
              {
                  "data": "CountNeeded",
                  "width": "10%"
              }, 
              ]
          });

          $('#dtProcess tbody').on('click', 'tr', function() {
              //只能选中单行
              if ( $(this).hasClass('selected') ) {
                  $(this).removeClass('selected');
              }
              else {
                  table.$('tr.selected').removeClass('selected');
                  $(this).addClass('selected');
              }

              //可以选中多行
              // $(this).toggleClass('selected');
          });
      });

      function reload() {
          table.ajax.reload()
      }
      function clearPos(){
          var b = confirm("确实要强制清空货位吗？")
          if (b == true) {
              var data = table.rows(".selected").data()
              if (data.length <= 0) {
                  return
              } else {
                  var id = data[0].PositionID
                  $.get("/ClearPosition?ShelfID={{.ShelfID}}&&ID=" + id, function(data) {
                      console.log(data)
                      if (data.Code == 0) {
                          reload()
                      } else {
                          alert(data.Message)
                      }
                  })
              }
          }        
      }
      function complteOrder() {
          var b = confirm("确实要强制完成订单的拣选吗？")
          if (b == true) {
              var data = table.rows(".selected").data()
              if (data.length <= 0) {
                  return
              } else {
                  var posID = data[0].PositionID
                  var orderID = data[0].OrderID
                  $.get("/CompleteOrderForced?ShelfID={{.ShelfID}}&&ID=" + orderID, function(data) {
                      console.log(data)
                      if (data.Code == 0) {
                          $.get("/ClearPosition?ShelfID={{.ShelfID}}&&ID=" + posID, function(data) {
                              console.log(data)
                              if (data.Code == 0) {
                                  reload()
                              } else {
                                  alert(data.Message)
                              }
                          })
                      } else {
                          alert(data.Message)
                      }
                  })
              }
          }
      }
    </script>
  </body>
</html>
