
$(function() {
       $("#opening-dialog").dialog({
         autoOpen: false,
         height: 480,
         width: 450,
         title: "Create Opening",
         modal: true,
         resizable:false,
         draggable:false
       });
 });


function openingDialog() {
  $("#opening-dialog").dialog("open");

} // openingDialog

$(function() {
       $("#confirm-dialog").dialog({
         autoOpen: false,
         height: 200,
         width: 400,
         title: "Reject-Operating Confirmation",
         modal: true,
         resizable:false,
         draggable:false,
         buttons:{
                    "Confirm":function(){
                                var candidatename = document.getElementById("candidatename").value;
                                //var candidatename = candidatename.replace(/[^\w\s]/gi," ");
                                var url="/candidates/" + encodeURIComponent(candidatename) + "/" + document.getElementById("candidateid").value + "/" + document.getElementById("openingid").value + "/reject";
                                //var url="/candidates"
                                goUrl(url);
                              },
                    "Cancel ":function(){
                       $(this).dialog("close");
                     } 
                 }
       });
 });


function confirmDialog(id,name,openingid) {
  $("#candidateid").val(id);
  $("#candidatename").val(name);
  $("#openingid").val(openingid);
  $("#confirm-dialog").dialog("open");
} // confirmDialog

$(function() {
       $("#confirm-dialog-remove").dialog({
         autoOpen: false,
         height: 200,
         width: 400,
         title: "Remove-Operating Confirmation",
         modal: true,
         resizable:false,
         draggable:false,
         buttons:{
                    "Confirm":function(){
                                var candidatename = document.getElementById("candidatename_remove").value;
                                //var candidatename = candidatename.replace(/[^\w\s]/gi," ");
                                var url="/candidates/" + encodeURIComponent(candidatename) + "/" + document.getElementById("candidateid_remove").value + "/" + document.getElementById("openingid_remove").value + "/remove";
                                //var url="/candidates"
                                goUrl(url);
                              },
                    "Cancel ":function(){
                       $(this).dialog("close");
                     }
                 }
       });
 });


function confirmRemoveDialog(id,name,openingid) {
  $("#candidateid_remove").val(id);
  $("#candidatename_remove").val(name);
  $("#openingid_remove").val(openingid);
  $("#confirm-dialog-remove").dialog("open");
} 



$(function() {
       $("#confirm-dialog-offer").dialog({
         autoOpen: false,
         height: 280,
         width: 460,
         title: "Make Offer-Operating Confirmation",
         modal: true,
         resizable:false,
         draggable:false,
         buttons:{
                    "Confirm":function(){
                                var summary = document.getElementById("summary").value;
                                if (summary == "Type your summary,100 characters only.")
                                {
                                  summary =" ";
                                }
                                //var summary = summary.replace(/[^\w\s]/gi," ");
                                var candidatename = document.getElementById("candidatename").value;
                                //var candidatename = candidatename.replace(/[^\w\s]/gi," ");
                                var url="/candidates/" + encodeURIComponent(candidatename) + "/" + document.getElementById("candidateid").value + "/" + document.getElementById("openingid").value + "/" + encodeURIComponent(summary) + "/offer";
                                //var url="/candidates"
                                goUrl(url);
                              },
                    "Cancel ":function(){
                       $(this).dialog("close");
                     }
                 }
       });
 });


function confirmOfferDialog(id,name,openingid) {
  $("#candidateid").val(id);
  $("#candidatename").val(name);
  $("#openingid").val(openingid);
  $("#confirm-dialog-offer").dialog("open");
} // confirmDialog



$(function() {
       $("#resume-dialog").dialog({
         autoOpen: false,
         height: 520,
         width: 450,
         title: "Create Candidate",
         modal: true,
         resizable:false,
         draggable:false
       });
 });


function resumeDialog() {
  $("#resume-dialog").dialog("open");

} // openingDialog

$(function() {
       $("#resume-dialog1").dialog({
         autoOpen: false,
         height: 520,
         width: 450,
         title: "Create Candidate",
         modal: true,
         resizable:false,
         draggable:false
       });
 });


function resumeDialog1(id,name) {
$("#openingid1").val(id);
$("#openingname").val(name);  
$("#resume-dialog1").dialog("open");
}


$(function() {
$("#recommend-dialog").dialog({
         autoOpen: false,
         height: 350,
         width: 400,
         title: "Recommend Candidate",
         modal: true,
         draggable:false
});
});

function recommendDialog() {
$("#boxsS").val(boxsvalue());
$("#recommend-dialog").dialog("open");
} // recommendDialog

function boxsvalue() {
var obj=document.getElementsByName('candidatebox');
var s="";
for(var i=0; i<obj.length; i++){  
    if(obj[i].checked) s+=obj[i].value+',';  //如果选中，将value添加到变量s中  
 }
return s ;
}

$(function() {
            $(':checkbox').click(function(){
                var s =  boxsvalue();
                if(s.length ==0){
                   $("#recommendbutton").attr("disabled","disabled");
                }else{
                   $("#recommendbutton").removeAttr("disabled");
                }

        	});
});


function selectvalue() {
   var selectcount=0;
   $("#recommendselect").each(function(){
      $(this).children("option:selected").each(function(){
         selectcount++;         
      });
    });
return selectcount ;
}

function  selectM() {
   if(selectvalue()==0){
      $("#RecommendButton").attr("disabled","disabled");
   }else{
      $("#RecommendButton").removeAttr("disabled");
   }
};

function goUrl(address) {

  window.location = address;

} // goUrl

function setReject(){
$("#reject-dialog").dialog("open"); 
}

$(function() {
$("#reject-dialog").dialog({
         autoOpen: false,
         height: 150,
         width: 400,
         title: "Reject Candidate",
         modal: true,
         draggable:false
});
});


$(function() {
       $("#comment-dialog").dialog({
         autoOpen: false,
         height: 550,
         width: 450,
         title: "Comment",
         modal: true,
         resizable:false,
         draggable:false
       });
 });


function commentDialog(openingcandidateid,pageid) {
  //alert(openingcandidateid);
  $("#openingcandidateid").val(openingcandidateid);
  $("#pageid").val(pageid);
  $("#comment-dialog").dialog("open");

} // commentDialog


$(function() {
		$( "#slider" ).slider({
			value:5.0,
			min: 0,
			max: 10,
			step: 0.1,
			slide: function( event, ui ) {
				$( "#amount" ).val( $( "#slider" ).slider( "value" ) );
			},
                        change:function(event,ui){
                              $( "#amount" ).val( $( "#slider" ).slider( "value" ) );
                        }
		});
		$( "#amount" ).val( $( "#slider" ).slider( "value" ) );
 
               $( "#slider1" ).slider({
                        value:5.0,
                        min: 0,
                        max: 10,
                        step: 0.1,
                        slide: function( event, ui ) {
                                $( "#amount1" ).val( $( "#slider1" ).slider( "value" ) );
                        },
                        change:function(event,ui){
                              $( "#amount1" ).val( $( "#slider1" ).slider( "value" ) );
                        }

                });
                $( "#amount1" ).val( $( "#slider1" ).slider( "value" ) );
   
                $( "#slider2" ).slider({
                        value:5.0,
                        min: 0,
                        max: 10,
                        step: 0.1,
                        slide: function( event, ui ) {
                                $( "#amount2" ).val( $( "#slider2" ).slider( "value" ) );
                        },
                        change:function(event,ui){
                              $( "#amount2" ).val( $( "#slider2" ).slider( "value" ) );
                        }

                });
                $( "#amount2" ).val( $( "#slider2" ).slider( "value" ) ); 

                $( "#slider3" ).slider({
                        value:5.0,
                        min: 0,
                        max: 10,
                        step: 0.1,
                        slide: function( event, ui ) {
                                $( "#amount3" ).val( $( "#slider3" ).slider( "value" ) );
                        },
                        change:function(event,ui){
                              $( "#amount3" ).val( $( "#slider3" ).slider( "value" ) );
                        }

                });
                $( "#amount3" ).val( $( "#slider3" ).slider( "value" ) );

                $( "#slider4" ).slider({
                        value:5.0,
                        min: 0,
                        max: 10,
                        step: 0.1,
                        slide: function( event, ui ) {
                                $( "#amount4" ).val( $( "#slider4" ).slider( "value" ) );
                        },
                        change:function(event,ui){
                              $( "#amount4" ).val( $( "#slider4" ).slider( "value" ) );
                        }

                });
                $( "#amount4" ).val( $( "#slider4" ).slider( "value" ) );

                $( "#slider5" ).slider({
                        value:5.0,
                        min: 0,
                        max: 10,
                        step: 0.1,
                        slide: function( event, ui ) {
                                $( "#amount5" ).val( $( "#slider5" ).slider( "value" ) );
                        },
                        change:function(event,ui){
                              $( "#amount5" ).val( $( "#slider5" ).slider( "value" ) );
                        }

                });
                $( "#amount5" ).val( $( "#slider5" ).slider( "value" ) );

                $( "#slider6" ).slider({
                        value:5.0,
                        min: 0,
                        max: 10,
                        step: 0.1,
                        slide: function( event, ui ) {
                                $( "#amount6" ).val( $( "#slider6" ).slider( "value" ) );
                        },
                        change:function(event,ui){
                              $( "#amount6" ).val( $( "#slider6" ).slider( "value" ) );
                        }

                });
                $( "#amount6" ).val( $( "#slider6" ).slider( "value" ) );

                $( "#slider7" ).slider({
                        value:5.0,
                        min: 0,
                        max: 10,
                        step: 0.1,
                        slide: function( event, ui ) {
                                $( "#amount7" ).val( $( "#slider7" ).slider( "value" ) );
                        },
                        change:function(event,ui){
                              $( "#amount7" ).val( $( "#slider7" ).slider( "value" ) );
                        }

                });
                $( "#amount7" ).val( $( "#slider7" ).slider( "value" ) );
               
	});


//pagination on frontend
var pn = 1;
var itemsPerPage = 0;
var back = 0;
var next = 0;
var lastPage = 0;
var nr = 0;
var container = null;
var docs = null;
var enteredTime = 0;
var searchDocs = [];
var docsObj = {};
var digitRegex = /^\d+$/;

//delegate dialogue
function delegateDialog(openingcandidateid,list_interviewer,pageid) {
 //alert(list_interviewer);
 $("#list_interviewer").val(list_interviewer);
 var interviewerlist = $("#list_interviewer").val().split("|");

 $("#documents > tbody").empty();
 $('#paginator').html('<div style="background-color:#FFF; border:#999 0px solid;"></div>');
 

 //interviewerlist =new Array("1","2","3"); 
 for(var i=0; i<interviewerlist.length; i++){
   if(interviewerlist[i] !="")
   {
    var interviewerinfo = interviewerlist[i].split(",");
    var stat = "";
    if(interviewerinfo[1] == 0 )
    {
      stat = "Notified"
    }
    else if (interviewerinfo[1] == 1)
    {
      stat = "Viewed"
    }
    else
    {
      stat = "Commented"
    }
    $("#documents").find('tbody')
         .append($('<tr>')
             .append($('<td>')
                 .text(interviewerinfo[0])
      )
             .append($('<td>')
                 .text(stat)
      )
    );
   }
 }

    container = $('#documents').find('tbody');

    docs = $('#documents').find('tbody').find('tr');
    nr = docs.length;
    docsObj = $('#documents tr:has(td)').map(function(i, v) {
        var $td = $('td', this);
        return {
            id: ++i,
            Username: $td.eq(0).text(),
            Status: $td.eq(1).text()
        };
    }).get();

    page_cnt=3;
    configPage(page_cnt);
    sortDocs('page');
    createPaginator();

    $('.page').live('click', function() {
        pn = $(this).data('page');
        configPage(page_cnt);
        sortDocs($(this).data('type'));
        createPaginator();
    });

    $('#items-per-page').change(function() {
        pn = 1;
        itemsPerPage = $(this).val();
        configPage(page_cnt);
        sortDocs('page');
        createPaginator();
    });

    $('#txt-search').keyup(function(e) {
        if ($.trim($(this).val()) != '') {
            var keyCode = (window.event) ? e.which : e.keyCode;
            if (keyCode === 13) {
                var results = jlinq.from(docsObj)
                    .ignoreCase()
                    .contains('name', $(this).val())
                    .or('age', $(this).val())
                    .or('grade', $(this).val())
                    .select();
                container.html('');
                if (results.length != 0) {
                    $.each(results, function(i, tr) {
                        searchDocs.push(docs.eq(tr.id - 1).get(0));
                    });
                    pn = 1;
                    nr = searchDocs.length;
                    configPage(page_cnt);
                    sortDocs('page');
                    createPaginator();
                } else {
                    searchDocs = [];
                    pn = 1;
                    nr = docs.length;
                    configPage(page_cnt);
                    sortDocs('page');
                    createPaginator();
                }
            }
        } else {
            searchDocs = [];
            pn = 1;
            nr = docs.length;
            configPage(page_cnt);
            sortDocs('page');
            createPaginator();
        }
    });

    $('#txt-page').keyup(function(e) {
        var keyCode = (window.event) ? e.which : e.keyCode;
        if (keyCode === 13) {
            var tmpPn = $.trim($(this).val());
            if (digitRegex.test(tmpPn)) {
                if (tmpPn.length != 0) {
                    if (tmpPn != 0) {
                        pn = parseInt(tmpPn);
                        configPage(page_cnt);
                        sortDocs('page');
                        createPaginator();
                    }
                }
            }
        }
    });

 $("#openingcandidateid1").val(openingcandidateid);
 $("#pageid_delegate").val(pageid);
 $("#delegate-dialog").dialog("open");
}


function configPage(pagecnt) {
    itemsPerPage = pagecnt;
    lastPage = Math.ceil(nr / itemsPerPage);

    if (pn < 1) {
        pn = 1;
    } else if (pn > lastPage) {
        pn = lastPage;
    }
}

function sortDocs(type) {
    var pageDocs = null;
    if (type === 'page') {
        if (searchDocs.length != 0) {
            if (pn === 1) {
                pageDocs = searchDocs.slice(0, (itemsPerPage * pn));
            } else {
                ++enteredTime;
                pageDocs = searchDocs.slice(itemsPerPage * (pn - 1), (itemsPerPage * pn));
            }
        } else {
            if (pn === 1) {
                pageDocs = docs.slice(0, (itemsPerPage * pn));
            } else {
                ++enteredTime;
                pageDocs = docs.slice(itemsPerPage * (pn - 1), (itemsPerPage * pn));
            }
        }
    } else if (type === 'back') {
        if (searchDocs.length != 0) {
            if (enteredTime === 0) {
                pageDocs = searchDocs.slice(itemsPerPage, (itemsPerPage * pn));
            } else {
                --enteredTime;
                pageDocs = searchDocs.slice(itemsPerPage * (pn - 1), (itemsPerPage * pn));
            }
        } else {
            if (enteredTime === 0) {
                pageDocs = docs.slice(itemsPerPage, (itemsPerPage * pn));
            } else {
                --enteredTime;
                pageDocs = docs.slice(itemsPerPage * (pn - 1), (itemsPerPage * pn));
            }
        }
    } else if (type === 'next') {
        ++enteredTime;
        if (searchDocs.length != 0) {
            if (enteredTime === 1) {
                pageDocs = searchDocs.slice(itemsPerPage, (itemsPerPage * pn));
            } else {
                pageDocs = searchDocs.slice(itemsPerPage * (pn - 1), (itemsPerPage * pn));
            }
        } else {
            if (enteredTime === 1) {
                pageDocs = docs.slice(itemsPerPage, (itemsPerPage * pn));
            } else {
                pageDocs = docs.slice(itemsPerPage * (pn - 1), (itemsPerPage * pn));
            }
        }
    }
    container.html(pageDocs);
}

function createPaginator() {

    var centerPages = '';
    var sub1 = pn - 1;
    var sub2 = pn - 2;
    var add1 = pn + 1;
    var add2 = pn + 2;

    if (pn === 1) {
        centerPages += '&nbsp; <span>' + pn + '</span> &nbsp;';
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + add1 + '" data-type="page">' + add1 + '</a> &nbsp;';
    } else if (pn === lastPage) {
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + sub1 + '" data-type="page">' + sub1 + '</a> &nbsp;';
        centerPages += '&nbsp; <span>' + pn + '</span> &nbsp;';
    } else if (pn > 2 && pn < (lastPage - 1)) {
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + sub2 + '" data-type="page">' + sub2 + '</a> &nbsp;';
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + sub1 + '" data-type="page">' + sub1 + '</a> &nbsp;';
        centerPages += '&nbsp; <span>' + pn + '</span> &nbsp;';
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + add1 + '" data-type="page">' + add1 + '</a> &nbsp;';
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + add2 + '" data-type="page">' + add2 + '</a> &nbsp;';
    } else if (pn > 1 && pn < lastPage) {
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + sub1 + '" data-type="page">' + sub1 + '</a> &nbsp;';
        centerPages += '&nbsp; <span>' + pn + '</span> &nbsp;';
        centerPages += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + add1 + '" data-type="page">' + add1 + '</a> &nbsp;';
    }

    var paginationDisplay = '';

    if (nr != 0) {
        if (lastPage != 1) {
            paginationDisplay += 'Page. <strong>' + pn + '</strong> of ' + lastPage;
            if (pn != 1) {
                back = pn - 1;
                paginationDisplay += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + back + '" data-type="back"><</a>';
            }
            paginationDisplay += '<span>' + centerPages + '</span>';
            if (pn != lastPage) {
                next = pn + 1;
                paginationDisplay += '&nbsp; <a href="javascript:void(0);" class="page" data-page="' + next + '" data-type="next">></a>';
            }
            $('#paginator').html('<div style="background-color:#FFF; border:#999 0px solid;">' + paginationDisplay + '</div>');
        }
        else {
            paginationDisplay = '';
            $('#paginator').html('<div style="background-color:#FFF; border:#999 0px solid;">' + paginationDisplay + '</div>');
        }
    }
    else {
        paginationDisplay = '';
    }
} //end pagination

//delegate dialogue 
$(function() {
$("#delegate-dialog").dialog({
         autoOpen: false,
         height: 630,
         width: 510,
         title: "Delegate Dialogue",
         modal: true,
         resizable:false,
         draggable:false,
          buttons:{
                    "Confirm":function(){
                                var list="";
                              $('select.multiselect2 option').each(function () {
                                 list+=this.value+","
                                  })
                                if(list != "")
                                {         
                                var url="/interviewers/" +document.getElementById("openingcandidateid1").value + "/" + document.getElementById("pageid_delegate").value + "/" + list;
                                //var url="/candidates"
                                goUrl(url);
                                }
                                else
                                {
                                  alert("Select your delegated users,or cancel this dialogue.");
                                }
                              },
                    "Cancel ":function(){
                       $(this).dialog("close");
                     }
                 },
        close: function() {
                        allFields.val( "" );
                        }
});
});

//delegate dialogue selection
$(function(){
$('.add').on('click', function() {
    var options = $('select.multiselect1 option:selected').sort().clone();
    var k=0;
    var option;
     while(option=options[k++])
    {
         var flag=0;
        $('select.multiselect2 option').each(function () { 
          if(this.text ==option.text && this.value== option.value)
          {
              flag = 1;
          }        
        })        
            if(flag==0)
            $('select.multiselect2').append(option);
    }
});
$('.addAll').on('click', function() {
    var options = $('select.multiselect1 option').sort().clone();
    $('select.multiselect2').append(options);
});
$('.remove').on('click', function() {
    $('select.multiselect2 option:selected').remove();
});
$('.removeAll').on('click', function() {
    $('select.multiselect2').empty();
});
});

function deleteRow(rowid)  
{   
    var row = document.getElementById(rowid);
    var table = row.parentNode;
    while ( table && table.tagName != 'TABLE' )
        table = table.parentNode;
    if ( !table )
        return;
    table.deleteRow(row.rowIndex);
}

var switch_flag = 0;
function notificationDialog(userid) {
  if (switch_flag == 0 && getCookie("userid") == 1 )
  {
  $("#sb-wrapper").html('<div id="sb-container" class="sb-card sb-on sb-card-notif"><div class="sb-card-arrow"></div><div class="sb-card-border" style="top: 60px"><div class="sna"></div><div id="sb-target"><table class="table table-hover table-striped mt20 sortable" id="noti_documents"><thead class="sortable colheader"><tr><th>Candidate Name</th><th>Link</th></tr><tbody></tbody></thead></table></div><div id=paginator style="margin-left:10px;"></div></div></div><div id="sb-onepick-target" class="sb-off" style="top: 0px;"></div>');  
    switch_flag =1;
    var link_url="";
   $.ajax({
     url: '/getNotifications/'+userid,
    success: function(data) {
      //JSON.stringify(data);
      /*if (1)
      {
        $("#sb-target").html('<span class="nonotification">No notifications,now...</span>');

      }*/
      $.each(data,function(i){
          link_url="/openings/opening_detail_single/"+data[i].interview_key + "/"+ data[i].openingid +"/"+
                   data[i].id ;
          $("#noti_documents").find('tbody')
            .append($('<tr id='+ i +'>')
             .append($('<td>')
                 .text(data[i].name)
           )
             .append($('<td>')
                .append($('<a>')
                 .nput-comment1attr('href',link_url)
                 .attr('target',"_blank")
                 .attr('onclick',"deleteRow("+i+");")
                 .text('Click to view detail')
             )
           )
         );
      });
     
        
    container = $('#noti_documents').find('tbody');
    docs = $('#noti_documents').find('tbody').find('tr');
    nr = docs.length;
    docsObj = $('#noti_documents tr:has(td)').map(function(i, v) {
        var $td = $('td', this);
        return {
            id: ++i,
            Username: $td.eq(0).text(),
            Status: $td.eq(1).text()
        };
    }).get();

    //pagination count
    var pagecnt =7;
    configPage(pagecnt);
    sortDocs('page');
    createPaginator();

    $('.page').live('click', function() {
        pn = $(this).data('page');
        configPage(pagecnt);
        sortDocs($(this).data('type'));
        createPaginator();
    });

    $('#items-per-page').change(function() {
        pn = 1;
        itemsPerPage = $(this).val();
        configPage(pagecnt);
        sortDocs('page');
        createPaginator();
    });

    $('#txt-search').keyup(function(e) {
        if ($.trim($(this).val()) != '') {
            var keyCode = (window.event) ? e.which : e.keyCode;
            if (keyCode === 13) {
                var results = jlinq.from(docsObj)
                    .ignoreCase()
                    .contains('name', $(this).val())
                    .or('age', $(this).val())
                    .or('grade', $(this).val())
                    .select();
                container.html('');
                if (results.length != 0) {
                    $.each(results, function(i, tr) {
                        searchDocs.push(docs.eq(tr.id - 1).get(0));
                    });
                    pn = 1;
                    nr = searchDocs.length;
                    configPage(pagecnt);
                    sortDocs('page');
                    createPaginator();
                } else {
                    searchDocs = [];
                    pn = 1;
                    nr = docs.length;
                    configPage(pagecnt);
                    sortDocs('page');
                    createPaginator();
                }
            }
        } else {
            searchDocs = [];
            pn = 1;
            nr = docs.length;
            configPage(pagecnt);
            sortDocs('page');
            createPaginator();
        }
    });

    $('#txt-page').keyup(function(e) {
        var keyCode = (window.event) ? e.which : e.keyCode;
        if (keyCode === 13) {
            var tmpPn = $.trim($(this).val());
            if (digitRegex.test(tmpPn)) {
                if (tmpPn.length != 0) {
                    if (tmpPn != 0) {
                        pn = parseInt(tmpPn);
                        configPage(pagecnt);
                        sortDocs('page');
                        createPaginator();
                    }
                }
            }
        }
    });
    //end pagination
     }
   });
  }
  else
  {
    $("#sb-wrapper").html('<div id="sb-container" class="sb-card sb-off sb-card-notif"></div>');
    switch_flag =0;
  }
  //setTimeout(notificationDialog, 5000);                           
} // notificationDialog

function IsJson(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}

var timeouts = [];
function notificationCnt() {
  if(getCookie("userid") == 1  )
  {
   var userid =document.getElementById("getUserid").value;
   $.ajax({
     url: '/getNotifications/'+ userid,
     dataType:'json',
    success: function(data) {
      $('#notifycnt').html(data.length);
    },
    error: function (){ //alert(timeouts.length);
                     for (var i = 0; i < timeouts.length; i++) {
                       clearTimeout(timeouts[i]);
                      }
                      //quick reset of the timer array you just cleared
                      timeouts = [];        
                  }
  });
  timeouts.push(setTimeout(notificationCnt, 10000) ) ;

  }
  // refresh page 
  // notificationDialog
}

$(document).ready(function() {
//page load 
 timeouts.push(setTimeout(notificationCnt, 1000));
} // notificationDialog
);

function deleteCookie() {
 
  // If the cookie exists
  if (getCookie("userid"))
    createCookie(0)
 //alert("after_logout: "+getCookie("userid"));

}

function getCookie(name){ 
   var strCookie=document.cookie; 
   var arrCookie=strCookie.split("; "); 
   for(var i=0;i<arrCookie.length;i++){ 
      var arr=arrCookie[i].split("="); 
      if(arr[0]==name)return arr[1]; 
   } 
   return ""; 
} 

function createCookie(value) {
  document.cookie = "userid="+value;
  //alert("after_login: "+getCookie("userid"));
}

//plugin to make any element text editable
$(document).ready(function() {
$.fn.extend({
	editable: function () {
		$(this).each(function () {
			var $el = $(this),
			$edittextbox = $('<input type="text"></input>').css('min-width', 50),

			submitChanges = function () {
				if ($edittextbox.val() !== '') {
					$el.html($edittextbox.val());
				}
                                else
                                {
                                  $el.html('Summary is empty.Double click to edit.');
                                }

                                $el.show();
                                $el.trigger('editsubmit', [$el.html()]);
                                $(document).unbind('click', submitChanges);
                                $edittextbox.detach();
			},
			tempVal;
			$edittextbox.click(function (event) {
				event.stopPropagation();
			});

			$el.dblclick(function (e) {
				tempVal = $el.html();
				$edittextbox.val(tempVal).insertBefore(this)
                .bind('keypress', function (e) {
					var code = (e.keyCode ? e.keyCode : e.which);
					if (code == 13) {
						submitChanges();
					}
				}).select();
				$el.hide();
				$(document).click(submitChanges);
			});
		});
		return this;
	}
});


//implement plugin
$('.summary_edit').editable().on('editsubmit', function (event, val) {
   if(getCookie("userid") == 1  )
  {
   //var summary = val.replace(/[^\w\s]/gi," ");
   var summary = val;
   var candidateid =document.getElementById("candidateid_offerpage").value;
   $.ajax({
     url: '/setCandidateSummary/'+ candidateid +'/' + encodeURIComponent(summary),
     success: function(data) {
       $("#summary_edit_id_"+candidateid).attr('title',summary);
     }
  });
  } //if ...
});
});

function getCandidateIdForSummary(id)
{
  $("#candidateid_offerpage").val(id);
}


