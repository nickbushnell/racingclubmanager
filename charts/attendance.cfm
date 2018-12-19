<!doctype html>
<html>
	<head>
		<title>Attendance Chart</title>
		<script src="chart.js"></script>
		<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
	</head>
	<body onload="init();" style="background-color: #263248; margin: 0px; padding: 0px;">
		<div>
			<div>
				<canvas id="canvas"></canvas>
			</div>
		</div>


	<script>
	
	function init() {
		document.getElementById("canvas").width = document.body.clientWidth;
	}

	var lineChartData = {
		labels : ["10/15","10/16","10/17","10/18","10/19","10/20","10/21"],
		datasets : [
			{
				label: "Forza 5",
				fillColor : "rgba(255,152,0,0.2)",
				strokeColor : "rgba(255,152,0,1)",
				pointColor : "rgba(255,152,0,1)",
				pointStrokeColor : "#fff",
				pointHighlightFill : "#fff",
				pointHighlightStroke : "rgba(255,152,0,1)",
				data : [16,15,14,6,8,10,5]
			}
		]

	}

	window.onload = function(){
		var ctx = document.getElementById("canvas").getContext("2d");
		myLine = new Chart(ctx).Line(lineChartData, {
			responsive: true,
			bezierCurve: false,
			scaleGridLineColor : "rgba(255,255,255,.08)",
			datasetFill : false,
			scaleFontColor: "#fff",
			scaleFontFamily: "'Monda', sans-serif",
			scaleFontSize: 16,
			maintainAspectRatio: true
		});
	}
	
	function addData() {
		myLine.addData([15,null], "10/22");
		myLine.addData([null,14], "10/23");
	}


	</script>
	
	
	</body>
</html>
