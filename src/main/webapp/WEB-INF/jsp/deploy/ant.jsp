<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Ant deployment</title>
	<%@ include file="../head.jsp" %>
	<meta name="${_csrf.parameterName}" content="${_csrf.token}"/>
	<!-- default header name is X-CSRF-TOKEN -->
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
<!-- 	<script src="/js/logging.js"></script>
	<script src="/js/deploy.js"></script> -->
</head>
<body>
	<%@ include file="../header.jsp" %>

	<fieldset>
		<legend>Tools</legend>
		<select id="group" name="group">
			<option value="">-- Group --</option>
		</select>
		<select id="project" name="project">
			<option value="">-- Group --</option>
		</select>
		<select id="branch" name="branch">
			<option value="">-- Branch --</option>
		</select>
		
		<!-- <input type="submit" id="submit" value="Deploy" /> -->
		<input type="button" id="deploy" value="Run" />
		<input type="reset" id="reset" value="Cancel" />
		<input type="button" id="config" value="Show config" />		
	</fieldset>

	<fieldset>
		<legend>Arguments</legend>
		<input type="checkbox" name="arguments" value="tgz" />Backup
		<input type="checkbox" name="arguments" value="clean" />Clean
		<input type="checkbox" name="arguments" value="pull" />Pull
		<input type="checkbox" name="arguments" value="push" />Merge
		<input type="checkbox" name="arguments" value="compile" />Compile
		<input type="checkbox" name="arguments" value="install" />Install
		<input type="checkbox" name="arguments" value="package" />Package
		<input type="checkbox" name="arguments" value="trial" />Trial
		<input type="checkbox" name="arguments" value="deploy" />Deploy
		<input type="checkbox" name="arguments" value="restart" />Restart
	</fieldset>

	<div id="error">
	</div>
	
	<fieldset>
		<legend>Screen output</legend>
		<ol id="output">
	
		</ol>
	</fieldset>

<script>
jQuery(document).ready(function() {
	
	var stompClient = null;
	
	function connect() {
	    var socket = new SockJS('/logging');
	    stompClient = Stomp.over(socket);
	    stompClient.connect({}, function (frame) {
	        //console.log('Connected: ' + frame);
	        stompClient.subscribe('/topic/log', function (protocol) {
	        	 $("#output").append("<li>" + JSON.parse(protocol.body).response + "</li>");
	        });
	    });
	}

	function disconnect() {
	    if (stompClient != null) {
	        stompClient.disconnect();
	    }
	    //console.log("Disconnected");
	}
	
    $.getJSON('/v1/config/group.json', function(data) {
		$.each(data,function(key, val) {
			$("#group").append('<option value="' + val + '">' + val + "</option>");
		});

	});
	
	$("#group").change(function() {

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

		var group = $("#group").val();		
		var project = $("#project").val();
		var branch = $("#branch").val();
		var url = "/v1/config/branch/" + group + "/"+project+".json";
		$.getJSON(url,function(data) {
			$.each(data, function(key, val) {
				$("#branch").append('<option value="' + val + '">' + val + "</option>");
			});
		});

	});
	
	jQuery("#config").click(function() {
		$("#output").html("");
		
		var group = $("#group").val();
		var project = $("#project").val();
		var branch = $("#branch").val();
		var url = "/v1/config/ant/build/" + group + "/"+project+ "/"+branch+".json";
		$.getJSON(url,function(data) {
			$.each(data, function(key, val) {
				$("#output").append("<li>" + key +"="+ val + "</li>");
			});
		});
	});
	jQuery("#deploy").click(function() {
		disconnect();
		connect();
		
		var group = $("#group").val();
		var project = $("#project").val();
		var branch = $("#branch").val();
		
		var arguments = (function() {
            var a = [];
            $("input[name='arguments']:checked").each(function() {
                a.push(this.value);
            });
            return a;
        })();
		
		var protocol = {
				'group': group,
				'project': project,
				'branch': branch,
				'arguments': arguments
				
		};

		console.log('json: ' + JSON.stringify(protocol));
		$("#output").html("");

		$.ajax({
	           type: "POST",
	           url: "/v1/deploy/ant.json",
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
	});
});
</script>

	<%@ include file="../footer.jsp" %>
</body>
</html>