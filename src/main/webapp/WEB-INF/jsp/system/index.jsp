<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>System</title>
	<%@ include file="../head.jsp" %>
</head>
<body>
	<%@ include file="../header.jsp" %>
	<br />

		<input id="host" list="hostList" name="host" size="16" />
    	<datalist id="hostList">
			<option value="127.0.0.1">localhost</option>
		</datalist> 
<!-- 
		<input id="db" list="dbList" name="db" size="2" />
		<datalist id="dbList">
			<option value="0"/>
			<option value="1"/>
			<option value="2"/>
			<option value="4"/>
			<option value="5"/>
			<option value="6"/>
			<option value="7"/>
			<option value="8"/>
			<option value="9"/>
			<option value="10"/>
			<option value="11"/>
			<option value="12"/>
			<option value="13"/>
			<option value="14"/>
			<option value="15"/>
			<option value="16"/>
		</datalist>

        <label for="keys">Keys</label>
        <input type="text" id="keys" list="keyList" size="64" class="form-control" value="*" placeholder="Your command here...">
 -->
    <button id="version" class="btn btn-default" type="button">Version</button>
    <button id="date" class="btn btn-default" type="button">Date</button>
    <button id="last" class="btn btn-default" type="button">Last</button>
    <button id="who" class="btn btn-default" type="button">Who</button>
    <button id="df" class="btn btn-default" type="button">df</button>
    <button id="ps" class="btn btn-default" type="button">ps</button>
    <button id="free" class="btn btn-default" type="button">free</button>
    <button id="ipaddr" class="btn btn-default" type="button">ip address</button>
    <button id="route" class="btn btn-default" type="button">route</button>
    <button id="ss" class="btn btn-default" type="button">listen</button>
    <button id="iptables" class="btn btn-default" type="button">iptables</button>
    <button id="history" class="btn btn-default" type="button">history</button>
    
	<fieldset>
		<legend>System setup</legend>
    	<button id="personalise" class="btn btn-default" type="button">Personalise</button>
    	<button id="epel" class="btn btn-default" type="button">epel-release</button>
    	<button id="selinux" class="btn btn-default" type="button">Disable selinux</button>
    	<button id="firewall" class="btn btn-default" type="button">Iptables</button>
    	<button id="ntp" class="btn btn-default" type="button">ntpd</button>
    	<button id="ssh" class="btn btn-default" type="button">SSH</button>
    	<button id="zmodem" class="btn btn-default" type="button">Zmodem</button>
	</fieldset>

	<fieldset>
		<legend>Screen output</legend>
		<pre id="output">
	
		</pre>
	</fieldset>
	
	<pre id="error">
	
	</pre>

	<script>
	jQuery(document).ready(function() {
		
	   var socket = new SockJS('/screen');
	   var stompClient = Stomp.over(socket);
	   
	   stompClient.connect({}, function (frame) {
	        console.log('Connected: ' + frame);
	        stompClient.subscribe('/topic/shell', function (protocol) {
	            $("#output").append(JSON.parse(protocol.body).response + "\r\n");
	        });
	    });
		    
		$.getJSON('/v1/config/host.json',function(data) {
			$.each(data,function(key, val) {
				$("#hostList").append('<option value="' + val + '">' + val	+ "</option>");
			});
		});
		
		jQuery("#version").click(function() {
			shell("cat /etc/issue /etc/centos-release");
		});
		jQuery("#date").click(function() {
			shell("date");
		});
		jQuery("#last").click(function() {
			shell("last");
		});
		jQuery("#who").click(function() {
			shell("who");
		});
		jQuery("#df").click(function() {
			shell("df -h");
		});
		jQuery("#ps").click(function() {
			shell("ps aux");
		});
		jQuery("#free").click(function() {
			shell("free -m");
		});
		
		jQuery("#ipaddr").click(function() {
			shell("/usr/sbin/ip addr");
		});
		
		jQuery("#route").click(function() {
			shell("/usr/sbin/ip route");
		});
		jQuery("#ss").click(function() {
			shell("/usr/sbin/ss -ntlp");
		});
		jQuery("#iptables").click(function() {
			shell("/usr/sbin/iptables-save");
		});
		jQuery("#history").click(function() {
			shell("history");
		});
		
		jQuery("#personalise").click(function() {
			shell("curl -s https://raw.githubusercontent.com/oscm/shell/master/os/personalise.sh | bash");
		});
		jQuery("#epel").click(function() {
			shell("curl -s https://raw.githubusercontent.com/oscm/shell/master/os/epel-release.sh | bash");
		});
		jQuery("#selinux").click(function() {
			shell("curl -s https://raw.githubusercontent.com/oscm/shell/master/os/selinux.sh | bash");
		});
		jQuery("#firewall").click(function() {
			shell("curl -s https://raw.githubusercontent.com/oscm/shell/master/os/iptables/iptables.sh | bash");
		});
		jQuery("#ntpd").click(function() {
			shell("curl -s https://raw.githubusercontent.com/oscm/shell/master/os/ntpd/ntp.sh | bash");
		});
		jQuery("#ssh").click(function() {
			shell("curl -s https://raw.githubusercontent.com/oscm/shell/master/os/ssh/sshd_config.sh | bash");
		});
		jQuery("#zmodem").click(function() {
			shell("curl -s https://raw.githubusercontent.com/oscm/shell/master/os/zmodem.sh | bash");
		});
		
		function shell(command){
			var host = $("#host").val();
			var protocol = {
					'request': command
			};
			console.log('json: ' + JSON.stringify(protocol));
			$("#output").html("");
			$.ajax({
	           type: "POST",
	           url: "/v1/system/shell/"+host+".json",
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
	});
	</script>
	<%@ include file="../footer.jsp" %>
</body>
</html>