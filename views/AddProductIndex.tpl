<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>添加产品</title>
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
    <script type="text/javascript" src="/javascripts/upload/ajaxfileupload.js"></script>
  </head>
  <body>

      <nav class="navbar navbar-default navbar-fixed-top" style="text-align: center;background-color: rgba(0,128,0,0.8);">
        <div class="container">
          <div class="row" id = "subNavBar" style="">
            <div class="col-xs-5 col-sm-5 col-md-5 col-md-lg-5" style="text-align: left;cursor:pointer;"  onclick="window.location.href='/'">
                <img src="/images/logo_pure.png" class="img-responsive" alt="Responsive image" style="width: 35px; margin-top: 6px;float: left;margin-right: 10px;">
                <div style="color: rgba(256,256,256,1); padding-top: 10px; font-size: 18px; margin-left: -50px;">配送站拣选系统</div>
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
        <div class="title" style="">添加产品</div>
        <!-- <p class="intro">111</p>         -->
        <div style="border-bottom: solid 1px rgba(0,0,0,0.2); margin-bottom: 30px;"></div>

        <form style="" action="/UploadProductInfo" method="post" enctype="multipart/form-data">
          <div class="form-group">
              <label for="exampleInputFile" style="font-size: 20px;margin-bottom: 15px;">通过excel文件导入</label>
              <input type="file" id="fileName" name="fileName">
              <p class="help-block">上传文件之前确定文件的格式正确</p>
          </div>
          <button type="button" class="btn btn-success btn-small" onclick="submitFile()">&nbsp;&nbsp;导 &nbsp; 入&nbsp;&nbsp;</button>
          <button type="button" class="btn btn-default btn-small" onclick="downloadFile()">下载模板</button>

        </form>

         <div style="border-bottom: solid 1px rgba(0,0,0,0.1); margin-bottom: 30px; margin-top: 30px;"></div>


<!--        <form >
          <label for="exampleInputFile" style="font-size: 20px;margin-bottom: 15px;">单个添加</label>
          <div class="form-group">
            <label for="exampleInputEmail1">产品编号</label>
            <input type="text" class="form-control" id="inputID" placeholder="例如 21234">
          </div>
          <div class="form-group">
            <label for="exampleInputPassword1">产品名称</label>
            <input type="text" class="form-control" id="inputName" placeholder="在下面列表中选择" disabled>
          </div>

                <button type="button" class="btn btn-success btn-small" onclick="submitOrder()">&nbsp;&nbsp;提 &nbsp; 交&nbsp;&nbsp;</button>
        </form>
        <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
          <div style="border-bottom: solid 1px rgba(0,0,0,0.1); margin-top: 10px;margin-bottom: 10px;"></div>
          <table id="dtProcess" class="display" cellspacing="0" width="100%" >
              <thead>
                  <tr>
                      <th>序号</th>
                      <th>名称</th>
                      <th>对应条码数量</th>
                      <th>是否本库商品</th>
                  </tr>
              </thead>
          </table>
        </div> -->

      </div>

      
    <script>
    var table;

    function downloadFile(){
      window.open("/files/商品sku导入模板.xlsx")
    }    
    function submitFile() {
        $.ajaxFileUpload({
            url: '/UploadProductInfo',
            secureuri: false,
            fileElementId: 'fileName',
            dataType: 'xlsx',
            success: function(data, status) {
                data = data.substring(data.indexOf("{"),data.indexOf("}")+1)
                console.log(data)
                var cmd = JSON.parse(data)
                if(cmd.Code == 0){
                  alert("数据导入成功")
                }else{
                  alert(cmd.Message)
                }
            }
        })
    }
    function submitOrder() {
        var productID = $("#inputID").val()
        var name = $("#inputName").val()
        console.log(productID)
        console.log(name)
        $.get("/AddProduct?ID=" + productID + "&name=" + convertPlus(name), function(data) {
            console.log(data)
            if (data.Code == 0) {
                alert("添加成功")
            } else {
                alert(data.Message)
            }
        })
    }
    function convertPlus(str){
      return str.replace(/\+/g, '%2B')
    }
      $(document).ready(function() {

          return
          table = $('#dtProcess').DataTable( {
              "columnDefs": [ {
                          "searchable": false,
                          "orderable": false,
                          "targets": 0
                      },{
                          "render": function ( data, type, row ) {//完成与否
                              if(row.ProductType == 0){
                                return "是"
                              }else{
                                return "否"
                              }
                          },
                          "targets": 3
                      }, 
                       ],
              "paging":   false,
              "ordering": true,
              "order": [
                  [2, "asc"]
              ],
              "info":     false,
              "searching":  true,
              "ajax": {
                "url":"/ProductNameList",
                "dataSrc":""
              },
              "columns": [
                  { "data": "Name" ,"width": "10%"},
                  // { "data": "Barcode" ,"width": "40%"},
                  { "data": "Name" ,"width": "50%"},
                  { "data": "BarcodeCount" ,"width": "20%"},
                  { "width": "20%"},
              ]
          } );
          table.on( 'order.dt search.dt', function () {
                  table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
                      cell.innerHTML = i+1;
                  } );
              } ).draw();
          
          $('#dtProcess tbody').on( 'click', 'tr', function () {
              //只能选中单行
              if ( $(this).hasClass('selected') ) {
                  $(this).removeClass('selected');
              }
              else {
                  table.$('tr.selected').removeClass('selected');
                  $(this).addClass('selected');
              }
              //将选中行的商品名称放到输入框中
              var data = table.rows(".selected").data()
              if (data.length <= 0) {
                  return
              }
              var name = data[0].Name
              $("#inputName").val(name)

              //可以选中多行
              // $(this).toggleClass('selected');
          } );
      });
    </script>
  </body>
</html>
