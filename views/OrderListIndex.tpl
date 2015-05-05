<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>订单列表</title>
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
                  <a class="btn btn-link" href="/NotConfirmedOrderItemsIndex" role="button" style=" color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">未处理的订单项</a>  
              </div>                             

          </div>
      </nav>


    <div role="main" class="main">

      <div class="container" style="margin-top:80px;">
          <div class="title" style="">订单列表</div>
          <p class="intro">管理当前订单</p>
          <div class="row" id = "subNavBar" style="">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div style="border-bottom: solid 1px rgba(0,0,0,0.2); margin-bottom: 30px;"></div>
                <button type="button" class="btn btn-default btn-small" onclick="reload()">&nbsp;&nbsp;刷 &nbsp; 新 &nbsp;&nbsp;</button>
                <button type="button" class="btn btn-success btn-small" onclick="openAddOrderIndex()">&nbsp;&nbsp;添 &nbsp; 加 &nbsp;&nbsp;</button>
                <button type="button" class="btn btn-success btn-small" onclick="openOrderDetailIndex()">&nbsp;&nbsp;详 &nbsp; 情 &nbsp;&nbsp;</button>
                <button type="button" class="btn btn-danger btn-small" style="margin-left:10px;" onclick="deleteRow()">&nbsp;&nbsp;删 &nbsp; 除&nbsp;&nbsp;</button>
                <button type="button" class="btn btn-danger btn-small" style="margin-left:10px;" onclick="clearCompletedOrders()">清空完成的订单</button>
                <div style="border-bottom: solid 1px rgba(0,0,0,0.1); margin-top: 10px;"></div>
                <table id="dtProcess" class="display" cellspacing="0" width="100%" >
                    <thead>
                        <tr>
                            <th></th>
                            <th>订单编码</th>
                            <th>是否完成</th>
                            <th>是否拣选中</th>
                            <!-- <th>货位编号</th> -->
                            <!-- <th>完成量</th> -->
                            <!-- <th>需求量</th> -->
                            <th>完成度</th>
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
                      {
                          "render": function ( data, type, row ) {//完成与否
                              if(row.CurrentItemCount == row.TotalItemCount){
                                return "是"
                              }else{
                                return "否"
                              }
                          },
                          "targets": 2
                      }, 
                      {
                          "render": function ( data, type, row ) {//完成与否
                              if(row.PositionID == 0){
                                return "否"
                              }else{
                                return "是（货位："+ row.PositionID +"）"
                              }
                          },
                          "targets": 3
                      },                     
                      {
                          "render": function ( data, type, row ) {//完成度 形式如：1/5
                              return row.CurrentItemCount + " / " + row.TotalItemCount;
                          },
                          "targets": 4
                      },

                      ],
              "paging": false,
              "ordering": true,
              "order": [
                  [2, "asc"]
              ],
              "info": false,
              "searching": true,
              "ajax": {
                  "url": "/OrderInfoList",
                  "dataSrc": ""
              },
              "columns": [{
                "data":"ID",
                "width": "5%"
              },{
                  "data": "ID",
                  "width": "35%"
              }, 
              {
                  // "data": "Completed",
                  "width": "20%"
              }, 
              {
                  // "data": "Located",
                  "width": "20%"
              }, 
              {
                  "width": "20%"
              }, 

              // {
              //     "data": "PositionID",
              //     "width": "20%"
              // }, 
              // {
              //     "data": "CurrentItemCount",
              //     "width": "10%"
              // }, {
              //     "data": "TotalItemCount",
              //     "width": "10%"
              // }, 
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
                  $.get("/RemoveOrder?ID=" + id, function(data) {
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
