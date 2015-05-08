<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>订单分配管理</title>
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
      .navbar-default .btn-link .nav-top-link{
        color:red;
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
                <div style="color: rgba(256,256,256,1); padding-top: 10px; font-size: 18px; margin-left: -50px;">配送站拣选系统</div>
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
                  <!-- <a class="btn btn-link" href="/m" role="button" style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">集合单拣选</a>    -->
              </div>    

              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/ProductManagementIndex" role="button" style="width: 100%; color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">产品管理</a>   -->
              </div>                             

          </div>
      </nav>


    <div role="main" class="main">

      <div class="container" style="margin-top:80px;">
          <div class="title" style="">订单分配管理</div>
          <p class="intro">查看订单与配送员的绑定信息</p>
          <div class="row" >
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                  <div style="border-bottom: solid 1px rgba(0,0,0,0.2); margin-bottom: 30px;"></div>
              </div>
              <div class="col-xs-6 col-sm-6 col-md-6 col-md-lg-6">
                <button type="button" class="btn btn-default btn-small" onclick="reload()">&nbsp;&nbsp;刷 &nbsp; 新 &nbsp;&nbsp;</button>
                <button type="button" class="btn btn-success btn-small" style="margin-left:10px;" onclick="openAddDistributeInfoIndex()">&nbsp;&nbsp;添&nbsp;加&nbsp;&nbsp; </button>
                <!-- <button type="button" class="btn btn-success btn-small" style="margin-left:10px;"  onclick="openPickupMergeOrderIndex()">开始拣选 </button> -->
                <!-- <button type="button" class="btn btn-success btn-small" onclick="openUpdateNewMergeOrderIndex()">更新集合单</button> -->
                <!-- <button type="button" class="btn btn-danger btn-small" style="margin-left:10px;" onclick="deleteRow()">&nbsp;&nbsp;删 &nbsp; 除&nbsp;&nbsp;</button> -->
              </div>

              <div class="col-xs-6 col-sm-6 col-md-6 col-md-lg-6" style="text-align: right;">
<!--                 <div class="form-inline">
                  <div class="form-group">
                    <label for="exampleInputName2" style="color: rgba(11,11,11,1);">查找集合单：</label>
                    <input type="text" class="form-control" id="inputOrderID" placeholder="输入订单编号">
                  </div>
                </div>
 -->              </div>

              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div style="border-bottom: solid 1px rgba(0,0,0,0.1); margin-top: 10px;margin-bottom: 10px;"></div>
              </div>
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <table id="dtProcess" class="display" cellspacing="0" width="100%" >
                    <thead>
                        <tr>
                            <th></th>
                            <th>订单编码</th>
                            <th>预定配送员</th>
                            <!-- <th>完成状态</th> -->
                        </tr>
                    </thead>
                </table>
              </div>
          </div>
      </div>
<!--       <nav class="navbar navbar-default navbar-fixed-bottom">
        <div class="container">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div id="blurAlert" class="alert alert-danger" role="alert" style="text-align: center;"></div>
              </div>
        </div>
      </nav>     -->      
    <script>
      var table;
      var orderIDToSearch = ""
      var mergedOrderTemp = null
      var tempInput = ""
        
      $(document).ready(function() {
          HideAlertMessage()

          table = $('#dtProcess').DataTable({
              "columnDefs": [{
                      "searchable": false,
                      "orderable": false,
                      "targets": 0
                  }, 

              ],
              // "dom": 'lrtip',
              "paging": false,
              "ordering": true,
              "info": false,
              "searching": true,
              "ajax": {
                  "url": "/OrderToExpressmanList",
                  "dataSrc": ""
              },
              "columns": [{
                  "data": "OrderID",
                  "width": "10%"
              }, {
                  "data": "OrderID",
                  "width": "40%"
              }, {
                  "data": "ExpressmanID",
                  "width": "40%"
              }, ]
          });
          table.on('order.dt search.dt', function() {
              table.column(0, {
                  search: 'applied',
                  order: 'applied'
              }).nodes().each(function(cell, i) {
                  cell.innerHTML = i + 1;
              });
          }).draw();

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
          // window.onfocus = function(){
          //   prepareBarcodeInput()
          // }
          // prepareBarcodeInput()
          // setInterval(submitOrder, 200)

      });
       function reload() {
           table.search("").draw()
           HideAlertMessage()
           table.ajax.reload()
       }
       function deleteRow() {
           var b = confirm("确实要删除这些数据吗？")
           if (b == true) {
               var data = table.rows(".selected").data()
               if (data.length <= 0) {
                   return
               } else {
                   var id = data[0].ID
                   var name = data[0].Name
                   $.get("/RemoveMergedOrder?ID=" + id, function(data) {
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
       function prepareBarcodeInput(){
         $("#inputOrderID").focus(function(){
             HideAlertMessage()
         });
         $("#inputOrderID").blur(function(){
           ShowAlertMessage("警告：页面已经失去焦点，扫描的条码失效")
         });

         $("#inputOrderID")[0].focus()        
       }
       //检查是否有条码录入，如果有，发起查询请求
       function submitOrder() {
           //条码枪没有后缀的解决方案
           var newInput = $("#inputOrderID").val()
               // if(newInput.length > 0){
               //   console.log("新输入值：" + newInput)
               // }
           if (newInput.length > 0) {
               if (newInput == tempInput) {
                   console.info("输入值确定为：" + newInput)
                   tempInput = ""
                   $("#inputOrderID").val("")

                   startToSearchMergedOrder(newInput)
               } else {
                   tempInput = newInput
               }
           }
       }
       function clickToStartToSearchMergedOrder(){
           var orderID = $("#inputOrderID").val()
           startToSearchMergedOrder(orderID)
       }


       function startToSearchMergedOrder(orderID) {
           console.log("搜索订单 "+orderID)
          orderIDToSearch = ""
           HideAlertMessage()
           // var orderID = $("#inputOrderID").val()
           if (orderID.length <= 0) {
               return
           }
           orderIDToSearch = orderID
           $.get("/GetMergeOrderInfoByOrderID?orderID=" + orderID, function(data) {
               console.log(data)
               if (data == null) {
                   console.error("系统异常")
               } else {
                   if (data.Code == 0) {
                       if (data.Data == null) {
                           var log = "没有查找到包含订单 【" + orderID + "】 的集合单"
                           console.info(log)
                           ShowAlertMessage(log)
                       } else {
                           console.log(data.Data)
                           mergedOrderTemp = data.Data
                           var mergedOrderID = data.Data.ID
                           console.info("查找到集合单编号为 " + mergedOrderID)
                           table.search(mergedOrderID).draw()
                           // $('#dtProcess').DataTable().search(mergedOrderID).draw()
                           HideAlertMessage()
                          // $("#inputOrderID").val("")
                       }
                   } else {
                       ShowAlertMessage(data.Message)
                   }
               }
           })
       }
       function openPickupMergeOrderIndex() {
           var data = table.rows(".selected").data()
           if (data.length <= 0) {
               return
           } else {
               var id = data[0].ID
               if(mergedOrderTemp == null){
                  alert("需要通过扫描订单查找到订单所在的集合单，才能进行集合单的拣选")
                  return
               }
               if(id != mergedOrderTemp.ID){
                  alert("你选择的集合单可能是错误的，订单不在该集合单内")
                  return
               }
               window.open("/PickUpMergedOrderIndex?ID=" + id)
           }
       }

        function openAddDistributeInfoIndex(){
          window.open("/AddDistributeInfoIndex")
        }
        function openUpdateNewMergeOrderIndex() {
            var data = table.rows(".selected").data()
            if (data.length <= 0) {
                return
            } else {
                var id = data[0].ID
                window.open("/MergeOrderIndex?mergedOrderID=" + id)
            }

        }
        // function openPickupMergeOrderIndex(){
        //   window.open("/m")

        // }
      function ShowAlertMessage(msg){
          $("#blurAlert").text(msg).show()
      }
      function HideAlertMessage(){
          $("#blurAlert").hide()
      }  
    </script>
  </body>
</html>
