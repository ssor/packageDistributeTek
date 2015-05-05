<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>订单详情</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="icon" 
          type="image/png" 
          href="/images/logo_pure.png"> 
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
  </head>
  <body>

      <nav class="navbar navbar-default navbar-fixed-top" style="text-align: center;background-color: rgba(0,128,0,0.8);">
        <div class="container">
          <div class="row" id = "subNavBar" style="">
            <div class="col-xs-5 col-sm-5 col-md-5 col-md-lg-5" style="text-align: left;cursor:pointer;"  onclick="window.location.href='/'">
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
                  <!-- <a class="btn btn-link" href="/ProductManagementIndex" role="button" style="width: 100%; color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">产品管理</a>   -->
              </div>                             

          </div>
      </nav>


      <div class="container" style="margin-top:80px;">
        <div class="title" style="">订单详情</div>
        <!-- <p class="intro">111</p>         -->
        <div style="border-bottom: solid 1px rgba(0,0,0,0.2); margin-bottom: 30px;"></div>
        <form class="form-horizontal">
          <div class="form-group" style="margin-bottom: 15px;">
              <label class="col-sm-2 control-label" style="text-align:left;color: rgba(0,0,0,0.5);">订单编号：</label>
              <div class="col-sm-10">
                <!-- <input id="inputID" type="text" class="form-control" id="inputPassword" placeholder=""> -->
                <p id="inputID" class="form-control-static" style="font-size: 18px; padding-top: 4px;"></p>
              </div>
          </div>     
          <div class="form-group" style="margin-bottom: 15px;">
              <label class="col-sm-2 control-label" style="text-align:left;color: rgba(0,0,0,0.5);">司机：</label>
              <div class="col-sm-10">
                <p id="inputDeliver" class="form-control-static" style="font-size: 18px; padding-top: 4px;"></p>
              </div>
          </div>     

          <div class="form-group" style="margin-bottom: 15px;">
              <label class="col-sm-2 control-label" style="text-align:left;color: rgba(0,0,0,0.5);">配送时间：</label>
              <div class="col-sm-10">
                <p id="inputDelivingTime" class="form-control-static" style="font-size: 18px; padding-top: 4px;"></p>
              </div>
          </div>     

          <div class="form-group" style="margin-bottom: 15px;">
              <label class="col-sm-2 control-label" style="text-align:left;color: rgba(0,0,0,0.5);">产品目录：</label>
          </div>
        </form>
        <div style="border-bottom: solid 1px rgba(0,0,0,0.1); margin-bottom: 30px; margin-top: 0px;"></div>
        <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
          <table id="dtProcess" class="display" cellspacing="0" width="100%" >
              <thead>
                  <tr>
                      <th>产品名称</th>
                      <!-- <th>需求量</th> -->
                      <!-- <th>完成量</th> -->
                      <th>完成度</th>
                  </tr>
              </thead>
          </table>
        </div>
      </div>     


      
    <script>
    var selectedOrderID = "{{ .orderID }}"
    $(document).ready(function() {

      $.get("/OrderDetail?ID=" + selectedOrderID, function(data){
        console.log(data)
        $("#inputID").text(data.ID)
        $("#inputDeliver").text(data.Deliver)
        $("#inputDelivingTime").text(data.DelivingTime)

      })

      table = $('#dtProcess').DataTable({
          "paging": false,
          "ordering": true,
          "order": [
              [0, "asc"]
          ],
          "info": false,
          "searching": false,
          "ajax": {
              "url": "/OrderDetail?ID=" + selectedOrderID,
              // "url": "/OrderItemsDetail?ID=" + selectedOrderID,
              "dataSrc": "Items"
          },
          "columnDefs": [
                      {
                          "render": function ( data, type, row ) {
                              return row.CurrentCount + " / " + row.CountNeeded;
                          },
                          "targets": 1
                      },
          ],

          "columns": [{
              "data": "ProductID",
              "width": "80%"
          }, 
          // {
          //     "data": "CountNeeded",
          //     "width": "20%"
          // }, {
          //     "data": "CurrentCount",
          //     "width": "20%"
          // }, 
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
    </script>
  </body>
</html>
