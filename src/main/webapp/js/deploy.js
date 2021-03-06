jQuery(document).ready(function() {

    connect();
	/*    
 	$.getJSON('/v1/config/group.json',function(data) {

		$.each(data,function(key, val) {
			$("#group").append('<option value="' + val + '">' + val	+ "</option>");
		});

	});

  	$("#group").change(function() {
  		$("#project").html('<option value="">-- Project --</option>');
		$.getJSON('/v1/config/envionment.json',	function(data) {
			$.each(data, function(key, val) {
				$("#envionment").append('<option value="' + val + '">' + val + "</option>");
			});

		});
	}); 
	
  	$("#envionment").change(function() {
		var envionment = $("#envionment option:selected").text();
		var group = $("#group").val();
		var env = $("#envionment").val();
		var prj = $("#project").val();
		var url = "/deploy/" + group + "/" + env;

		$("#envionment").html('<option value="">-- Envionment --</option>');

		$.getJSON('/v1/config/project/' + group + '/' + envionment + '.json',

		function(data) {

			$.each(data, function(key, val) {
				$("#project").append('<option value="' + val + '">' + val + "</option>");
			});

		});

	});    
	*/
    
    $.getJSON('/v1/config/group.json', function(data) {
		$.each(data,function(key, val) {
			$("#group").append('<option value="' + val + '">' + val + "</option>");
		});

	});
	
	$("#group").change(function() {
		$("#project").html('<option value="">-- Project --</option>');
		var group = $("#group").val();
		var env = $("#branch").val();
		var prj = $("#project").val();
		var url = "/v1/config/project/" + group + ".json";	
		$.getJSON(url,function(data) {

			$.each(data, function(key, val) {
				$("#project").append('<option value="' + val + '">' + val + "</option>");
			});

		});

	});
	
	$("#project").change(function() {
		$("#branch").html('<option value="">-- Branch --</option>');
		var group = $("#group").val();
		var branch = $("#branch").val();
		var project = $("#project").val();
		var url = "/v1/config/branch/" + group + "/"+project+".json";
		$.getJSON(url,function(data) {
			$.each(data, function(key, val) {
				$("#branch").append('<option value="' + val + '">' + val + "</option>");
			});
		});

	});
    
	jQuery("#deploy").click(function() {
		jQuery("#output").html("");
		
		var group = $("#group").val();
		var project = $("#project").val();
		var branch = $("#branch").val();
		var url = "/v1/deploy/config/" + group +"/"+project+"/"+ branch +"/";
		
		var data = $.getJSON(url,
			function(data) {
				if(data.status){
					jQuery("#status").html("Starting...")
				}
			});
	});
		
	jQuery("#backup").click(function() {
		manual(["ant","tgz"]);
	});
	jQuery("#restart").click(function() {
		manual(["ant","restart"]);
	});
	jQuery("#start").click(function() {
		manual(["ant","start"]);
	});
	jQuery("#stop").click(function() {
		manual(["ant","stop"]);
	});
	jQuery("#merge").click(function() {
		manual(["ant","push"]);
	});
	
	jQuery("#run").click(function() {
		var arguments = (function() {
            var a = [];
            $("input[name='arguments']:checked").each(function() {
                a.push(this.value);
            });
            return a;
        })();
		manual(arguments);
	});
	
	function manual(argv){
		var group = $("#group").val();
		var project = $("#project").val();
		var branch = $("#branch").val();
		
		var protocol = {
				'group': group,
				'project': project,
				'branch': branch,
				'arguments': argv
				
		};
		
		console.log('json: ' + JSON.stringify(protocol));
		$("#output").html("");

		$.ajax({
           type: "POST",
           url: "/v1/deploy/manual.json",
           dataType: "json",
           contentType: 'application/json',
           data: JSON.stringify(protocol),
           success: function (msg) {
               if (msg.status) {
            	   $('#error').html( "Sent" );
               } else {
                   alert("Cannot add to list !");
               }
           }
       });				
		
	}
		
	jQuery("#ant").click(function() {
		$("input[value=mvn]").prop("checked", false);
		$("input[value=deployment]").prop("checked", false);

		$("input[value=tgz]").prop("checked", false);
		//$("input[value=deploy]").attr("checked", "checked");
		$("input[value=restart]").prop("checked", true);
	});
	jQuery("#mvn").click(function() {
		$("input[value=ant]").prop("checked", false);
		$("input[value=deployment]").prop("checked", false);

		$("input[value=tgz]").prop("checked", true);
		$("input[value=pull]").prop("checked", true);
		$("input[value=install]").prop("checked", true);
		$("input[value=deploy]").prop("checked", true);
		$("input[value=deployment]").prop("checked", false);

	});
	jQuery("#deployment").click(function() {
		$("input[value=ant]").prop("checked", false);
		$("input[value=mvn]").prop("checked", false);
	});
	jQuery("#clean").click(function() {
		jQuery("#output").html("");
	});
	
		
});