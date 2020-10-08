function checkFirstForm() {
	var i = 0;
	$('.faqja_1 [id^="kerkesa_"]').each(function(index,item){
		if(item.value==""){
			i++;
			var str = item.id.split("_");
			str.shift();
			str = str.join("_");
			$('[id^="error_' + str + '"]').css({'display':'block'});
			$(".errorat").css({'display':'block'});
		}

	});
	if(i==0){
		$(".errorat").css({'display':'none'});
		$(".faqja_1").css({'display':'none'});
		if($("#kerkesa_lloji_pushimit").val()=="Pushim Vjetor"){
			$(".faqja_2").css({'display':'block'});
		}
		else{
			$(".faqja_3").css({'display':'block'});
		}
	}
};
function checkSecondForm() {
	var i = 0;
	$('.faqja_2 [id^="kerkesa_"]').each(function(index,item){
		if(item.value==""){
			i++;
			var str = item.id.split("_");
			str.shift();
			str = str.join("_");
			$('[id^="error_' + str + '"]').css({'display':'block'});
			$(".errorat").css({'display':'block'});
		}

	});
	if(i==0){
		var data_fillimit = $('.faqja_2 #kerkesa_data_fillimit').val();
		var data_mbarimit = $('.faqja_2 #kerkesa_data_mbarimit').val();
		$('.faqja_3 #kerkesa_data_fillimit').val(data_fillimit);
		$('.faqja_3 #kerkesa_data_mbarimit').val(data_mbarimit);
		$("#kerkesa_data_fillimit").closest('form').submit();
	}
};
function checkThirdForm() {
	var i = 0;
	$('.faqja_3 [id^="kerkesa_"]').each(function(index,item){
		if(item.id.split("_")[1] == "file"){
			return;
		}
		if(item.value==""){
			i++;
			var str = item.id.split("_");
			str.shift();
			str = str.join("_");
			$('[id^="error_' + str + '"]').css({'display':'block'});
			$(".errorat").css({'display':'block'});
		}
		if($(".faqja_3 #kerkesa_file").get(0).files.length==0){
			$("#errorat_file").css({'display':'block'});
		}

	});
	if(i==0){
		$("#kerkesa_data_fillimit").closest('form').submit();
	}
};
function shkoPas(elem) {
	if(elem=="mjeks"){
		$(".faqja_3").css({'display':'none'});
	}else {
		$(".faqja_2").css({'display':'none'});
	}
	$(".faqja_1").css({'display':'block'});
}
$(document).on('turbolinks:load', function() {
	document.getElementById('kerkesa_file').onchange = function () {
		document.getElementById('fileInputSpan').classList.add("selected_files");
		$("#errorat_file").innerHTML = ($("#kerkesa_file").val().replace(/^.*[\\\/]/, ''));
	};
	if($(".faqja_3 #kerkesa_file").get(0).files.length>0){
		document.getElementById('fileInputSpan').classList.add("selected_files");
		$("#errorat_file").innerHTML = ($("#kerkesa_file").val().replace(/^.*[\\\/]/, ''));
	}
	$(document).on("keypress", 'form', function (e) {
		var code = e.keyCode || e.which;
		if (code == 13) {
			e.preventDefault();
			return false;
		}
	});
	$('[id^="error_"]').css({'display':"none"});
	$('[id^="kerkesa_"]').each(function(index,item){
		item.onfocus = function(){
			var str = item.id.split("_");
			str.shift();
			str = str.join("_");
			$('[id^="error_' + str + '"]').css({'display':'none'});
			$(".errorat").css({'display':'none'});
		};
	});

});
