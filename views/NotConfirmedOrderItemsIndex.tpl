<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>未处理订单列表</title>
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
 

              <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3"  style="text-align: right;">
                  <!-- <a class="btn btn-link" href="/NotConfirmedOrderItemsIndex" role="button" style=" color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">未处理的订单项</a>   -->
              </div>                             

          </div>
      </nav>


    <div role="main" class="main">

      <div class="container" style="margin-top:80px;">
          <div class="title" style="">未处理订单列表</div>
          <p class="intro">确认订单项是否在本库中拣选，选择加入本库或者过滤掉</p>
          <div class="row" id = "subNavBar" style="">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div style="border-bottom: solid 1px rgba(0,0,0,0.2); margin-bottom: 30px;"></div>
                <button type="button" class="btn btn-default btn-small" onclick="reload()">&nbsp;&nbsp;刷 &nbsp; 新 &nbsp;&nbsp;</button>
                <button type="button" class="btn btn-success btn-small" onclick="AddOrderItem()">添加到本库</button>
                <button type="button" class="btn btn-success btn-small" onclick="IgnoreOrderItem()">不属于本库</button>
                <!-- <button type="button" class="btn btn-danger btn-small" style="margin-left:10px;" onclick="deleteRow()">&nbsp;&nbsp;删 &nbsp; 除&nbsp;&nbsp;</button> -->
                <!-- <button type="button" class="btn btn-danger btn-small" style="margin-left:10px;" onclick="clearCompletedOrders()">清空完成的订单</button> -->
                <div style="border-bottom: solid 1px rgba(0,0,0,0.1); margin-top: 10px;"></div>
                <table id="dtProcess" class="display" cellspacing="0" width="100%" >
                    <thead>
                        <tr>
                            <th></th>
                            <th>订单编码</th>
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
              "columnDefs": [ {
                          "searchable": false,
                          "orderable": false,
                          "targets": 0
                      } ,
                      ],
              "paging": false,
              "ordering": true,
              "order": [
                  [1, "asc"]
              ],
              "info": false,
              "searching": true,
              "ajax": {
                  "url": "/NotConfirmedOrderItemList",
                  "dataSrc": ""
              },
              "columns": [{
                "data":"OrderID",
                "width": "15%"
              },{
                  "data": "OrderID",
                  "width": "20%"
              }, 
              {
                  "data": "ProductID",
                  "width": "50%"
              }, 
              {
                  "data": "CountNeeded",
                  "width": "15%"
              }, 

              ]
          });

          table.on( 'order.dt search.dt', function () {
                  table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
                      cell.innerHTML = i+1;
                  } );
              } ).draw();
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
      function AddOrderItem(){
        var data = table.rows(".selected").data()
        if (data.length <= 0) {
            return
        }
        var OrderID = data[0].OrderID
        var ProductID = data[0].ProductID
        var CountNeeded = data[0].CountNeeded
        var b = confirm("确实订单 "+ OrderID +" 中的 "+ProductID+" 要在本库拣选吗？")
        if(b == true){
          $.get("/ConfirmOrderItemIn?OrderID=" + OrderID + "&ProductID="+convertPlus(ProductID), function(data) {
              console.log(data)
              if (data.Code == 0) {
                  reload()
              } else {
                  alert(data.Message)
              }
          })
        }
      }
      function convertPlus(str){
        return str.replace(/\+/g, '%2B')
      }
      function IgnoreOrderItem(){
        var data = table.rows(".selected").data()
        if (data.length <= 0) {
            return
        }
        var OrderID = data[0].OrderID
        var ProductID = data[0].ProductID
        var b = confirm("确实订单 "+ OrderID +" 中的 "+ProductID+" 要在本库拣选吗？")
        if(b == true){
          $.get("/ConfirmOrderItemNotIn?OrderID=" + OrderID + "&ProductID="+convertPlus(ProductID), function(data) {
              console.log(data)
              if (data.Code == 0) {
                  reload()
              } else {
                  alert(data.Message)
              }
          })
        }
      }
      function clearCompletedOrders() {
          var b = confirm("确实要删除这些订单吗？")
          if (b == true) {
              $.get("/ClearCompletedOrders", function(data) {
                  console.log("ClearCompletedOrders =>")
                  console.log(data)
                  if (data.Code == 0) {
                      reload()
                  } else {
                      alert(data.Message)
                  }
              })
          }
      }
      function deleteRow() {
          var b = confirm("确实要删除这些数据吗？")
          if (b == true) {
              var data = table.rows(".selected").data()
              if (data.length <= 0) {
                  return
              } else {
                  var id = data[0].ID
                  $.get("/RemoveProduct?ID=" + id, function(data) {
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
      function openOrderDetailIndex() {
          var data = table.rows(".selected").data()
          if (data.length <= 0) {
              return
          } else {
              var id = data[0].ID
              window.open("/OrderDetailIndex?ID=" + id)
          }        
      }
      function openAddOrderIndex() {
          window.open("/AddOrderIndex")
      }
    </script>
  </body>
</html>
