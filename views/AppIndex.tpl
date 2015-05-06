<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>配送站拣选系统</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="icon" 
          type="image/png" 
          href="/images/logo_pure.png"> 
    <link href="/bootstrap/css/bootstrap.css" rel="stylesheet" media="screen">    
    <style type="text/css">
        /* 升级过程中的等待动画       */
        .spinner {
          margin: 20px auto;
          width: 50px;
          height: 60px;
          text-align: center;
          font-size: 10px;
        }
         
        .spinner > div {
          background-color: #67CF22;
          height: 100%;
          width: 6px;
          display: inline-block;
           
          -webkit-animation: stretchdelay 1.2s infinite ease-in-out;
          animation: stretchdelay 1.2s infinite ease-in-out;
        }
         
        .spinner .rect2 {
          -webkit-animation-delay: -1.1s;
          animation-delay: -1.1s;
        }
         
        .spinner .rect3 {
          -webkit-animation-delay: -1.0s;
          animation-delay: -1.0s;
        }
         
        .spinner .rect4 {
          -webkit-animation-delay: -0.9s;
          animation-delay: -0.9s;
        }
         
        .spinner .rect5 {
          -webkit-animation-delay: -0.8s;
          animation-delay: -0.8s;
        }
         
        @-webkit-keyframes stretchdelay {
          0%, 40%, 100% { -webkit-transform: scaleY(0.4) } 
          20% { -webkit-transform: scaleY(1.0) }
        }
         
        @keyframes stretchdelay {
          0%, 40%, 100% {
            transform: scaleY(0.4);
            -webkit-transform: scaleY(0.4);
          }  20% {
            transform: scaleY(1.0);
            -webkit-transform: scaleY(1.0);
          }
        }
        /*   首页中间的动画     */


        .base {
          height: 9em;
          left: 50%;
          margin: -7.5em;
          padding: 3em;
          position: absolute;
          top: 50%;
          width: 9em;
          transform: rotateX(45deg) rotateZ(45deg);
          transform-style: preserve-3d;
        }

        .cube,
        .cube:after,
        .cube:before {
          content: '';
          float: left;
          height: 3em;
          position: absolute;
          width: 3em;
        }

        /* Top */
        .cube {
          background-color: #05afd1;
          position: relative;
          transform: translateZ(3em);
          transform-style: preserve-3d;
          transition: .25s;
          box-shadow: 13em 13em 1.5em rgba(0, 0, 0, 0.1);
          animation: anim 1s infinite;
        }
        .cube:after {
          background-color: #049dbc;
          transform: rotateX(-90deg) translateY(3em);
          transform-origin: 100% 100%;
        }
        .cube:before {
          background-color: #048ca7;
          transform: rotateY(90deg) translateX(3em);
          transform-origin: 100% 0;
        }
        .cube:nth-child(1) {
          animation-delay: 0.05s;
        }
        .cube:nth-child(2) {
          animation-delay: 0.1s;
        }
        .cube:nth-child(3) {
          animation-delay: 0.15s;
        }
        .cube:nth-child(4) {
          animation-delay: 0.2s;
        }
        .cube:nth-child(5) {
          animation-delay: 0.25s;
        }
        .cube:nth-child(6) {
          animation-delay: 0.3s;
        }
        .cube:nth-child(7) {
          animation-delay: 0.35s;
        }
        .cube:nth-child(8) {
          animation-delay: 0.4s;
        }
        .cube:nth-child(9) {
          animation-delay: 0.45s;
        }

        @keyframes anim {
          50% {
            transform: translateZ(0.5em);
          }
        }
    </style>

    <script src="/javascripts/jquery.min.js" type="text/javascript"></script> 
    <script src="/javascripts/prefixfree.min.js"></script>
    <script src="/bootstrap/js/bootstrap.min.js"></script>
  </head>
  <body >

      <nav class="navbar navbar-default navbar-fixed-top" style="text-align: center;background-color: rgba(0,128,0,0.8);">
        <div class="container">
          <div class="row" id = "subNavBar" style="">
            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: left;" >
                <img src="/images/logo_pure.png" class="img-responsive" alt="Responsive image" style="width: 35px; margin-top: 6px;float: left;margin-right: 10px;">
                <div  style="color: rgba(256,256,256,1); padding-top: 10px; font-size: 18px; margin-left: -50px;">配送站拣选系统
                  <span id="updateTip" style="font-size: 14px; color: red; font-weight: bold;cursor:pointer;" onclick="startUpdateWaiting()">升级</span>
                </div>
            </div>
            <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                <a class="btn btn-link" href="/OrderListIndex" target="_blank"  role="button" style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;margin-left: -80px;">订单管理</a>   
            </div>    
            <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                <a class="btn btn-link" href="/OrderToExpressmanManagementIndex"  target="_blank" role="button" style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;margin-left: -80px;">订单分配信息</a>   
            </div>    

            <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                <a class="btn btn-link" href="/ProductManagementIndex" target="_blank"  role="button" style="width: 100%; color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;margin-left: -30px;">产品管理</a>  
            </div>                
            <div class="col-xs-4 col-sm-4 col-md-4 col-md-lg-4" style="text-align: left;"> </div>

             <!-- <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
               <a class="btn btn-link" href="/m"  target="_blank" role="button" style="width: 100%; color: rgba(256,256,256,0.9); padding-top: 10px; font-size: 16px;"><span class="glyphicon glyphicon-sort-by-attributes" aria-hidden="true" style="margin-right: 5px; top: 3px;"></span>集合单拣选</a> 
            </div>-->
            <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2">
                <a class="btn btn-link" href="/PickUpIndex" target="_blank" role="button" style="width: 100%; color: rgba(256,256,256,0.9); padding-top: 10px; font-size: 16px;"><span class="glyphicon glyphicon-sort-by-attributes-alt" aria-hidden="true" style="margin-right: 5px; top: 3px;"></span>开始拣选</a>
            </div>
                         

          </div>
      </nav>


      <div class="container" style="margin-top:65px;">
        <div class="row">
          <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12"  style="min-height: 260px; font-size: 9px; margin-bottom: 70px;">
                <div class='base' style="box-sizing: content-box;">
                      <div class='cube'></div>
                      <div class='cube'></div>
                      <div class='cube'></div>
                      <div class='cube'></div>
                      <div class='cube'></div>
                      <div class='cube'></div>
                      <div class='cube'></div>
                      <div class='cube'></div>
                      <div class='cube'></div>
                </div>
              <!-- <img src="/images/clock.png" class="img-responsive" alt="Responsive image" style="max-width: 450px; margin-top: 0px;margin-right: 10px;display: inline;"> -->

          </div>
          <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12"  style="text-align: center; font-size: 22px; margin-top: 10px; border-top: solid 1px rgba(111,111,111,0.3); padding-top: 25px;">
            忙碌和紧张，能带来高昂的工作情绪；只有全神贯注时，工作才能产生高效率
          </div>
          
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2"  style="text-align:center;font-size:16px;margin-top:10px;"></div>
          <div class="col-xs-8 col-sm-8 col-md-8 col-md-lg-8"  style="text-align:right;font-size:14px;margin-top:10px;">
            ——松下幸之助
          </div>
          <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2"  style="text-align:center;font-size:16px;">
          </div>
          <!-- <div class="time" style="text-align:center;"><span id="currtime">00:00:00</span><em></em></div> -->
        </div>
      </div>

      <nav class="navbar navbar-default navbar-fixed-bottom">
        <div class="container">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div id="blurAlert" class="alert " role="alert" style="text-align: center;font-size:15px;color: rgba(111,111,111,0.6);">配送站拣选系统（0.1）</div>
              </div>
        </div>
      </nav> 

    <script>
    $(document).ready(function() {
      var updateTip = $("#updateTip")
      updateTip.hide()
      setInterval(checkUpdate, 60*1000)
    });

    function checkUpdate() {
      var updateTip = $("#updateTip")
        $.get("/NewUpdate", function(data) {
            if (data.Code == 0) {
               console.log("发现升级信息")
                updateTip.show()
            }else{
               console.log("没有升级信息")
              updateTip.hide()
            }
        })
    }
    function startUpdateWaiting() {
        var r = confirm("系统可以升级了，是否现在升级？")
        if (r == true) {
            try {
                $.get("/UpdateNow", function(data) {})
            } catch (err) {
            }

            $('#myModal').modal('show')
            setInterval(function() {
                $.get("/TestAlive", function(data, status) {
                    console.log(status)
                    if (status == "success") {
                        console.info("升级完毕")
                        $('#myModal').modal('hide')
                    }
                })
            }, 2000)
        }
    }
    function ShowAlertMessage(msg){
        $("#blurAlert").text(msg).show()
    }
    function HideAlertMessage(){
        $("#blurAlert").hide()
    }    
    </script>

    <div class="modal fade" id="myModal" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="margin-top: 200px;">
          <div class="modal-content">
            <div class="modal-header">
              <!-- <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button> -->
              <h4 class="modal-title" id="gridSystemModalLabel" style="text-align: center;">系统升级中</h4>
            </div>
            <div class="modal-body">
                <div class="spinner">
                  <div class="rect1"></div>
                  <div class="rect2"></div>
                  <div class="rect3"></div>
                  <div class="rect4"></div>
                  <div class="rect5"></div>
                </div>              
              
            </div>

          </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
      </div><!-- /.modal -->

  </body>
</html>
