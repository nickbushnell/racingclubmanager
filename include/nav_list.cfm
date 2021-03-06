/* Main menu settings */
/* this version of nav_list only used on admin_races_results.cfm */
#centeredmenu {
	clear:both;
	float:left;
	margin:0;
	padding:0;
	width:100%;
	font-family: 'Monda', sans-serif;
	z-index:1000; /* This makes the dropdown menus appear above the page content below */
	position:relative;
	font-size:14pt;
}

/* Top menu items */
#centeredmenu ul {
	margin:0;
	padding:0;
	list-style:none;
	float:left;
	/*position:relative;*/
	/*right:50%;*/
}
#centeredmenu ul li {
	margin:0 0 0 1px;
	padding:0;
	float:left;
	position:relative;
	/*left:50%;*/
	top:1px;
}
#centeredmenu ul li a {
	display:block;
	margin:0;
	padding:.6em .5em .4em;
	line-height:1em;
	
	text-decoration:none;
	color:#444;
	font-weight:bold;
	
}

#centeredmenu ul li a:hover {
	color:#fff;
}
#centeredmenu ul li:hover a,
#centeredmenu ul li.hover a { /* This line is required for IE 6 and below */
	color:#fff;
}

/* Submenu items */
#centeredmenu ul ul {
	display:none; /* Sub menus are hidden by default */
	position:absolute;
	top:2em;
	left:0;
	float:left;
	right:auto; /*resets the right:50% on the parent ul */
	width:10em; /* width of the drop-down menus */
	z-index:1001;
}
#centeredmenu ul ul li {
	left:auto;  /*resets the left:50% on the parent li */
	margin:0; /* Reset the 1px margin from the top menu */
	clear:left;
	float:left;
	width:100%;
}
#centeredmenu ul ul li a,
#centeredmenu ul li:hover ul li a,
#centeredmenu ul li.hover ul li a { /* This line is required for IE 6 and below */
	font-weight:normal; /* resets the bold set for the top level menu items */
	text-align: right;
	color:#444;
	line-height:1.4em; /* overwrite line-height value from top menu */
	float:left;
	width:100%;
	     background:       #FF9800;}
.block { background-color: #FF9800;}
.title { color:            #FF9800;}
#centeredmenu ul ul li a:hover,
#centeredmenu ul li:hover ul li a:hover,
#centeredmenu ul li.hover ul li a:hover { /* This line is required for IE 6 and below */
	color:white;
	float:left;
}

/* Flip the last submenu so it stays within the page */
#centeredmenu ul ul.last {
	left:auto; /* reset left:0; value */
	right:0; /* Set right value instead */
}
#centeredmenu ul ul.last li {
	float:right;
	position:relative;
	right:.8em;
}

/* Make the sub menus appear on hover */
#centeredmenu ul li:hover ul,
#centeredmenu ul li.hover ul { /* This line is required for IE 6 and below */
	display:block; /* Show the sub menus */
}

.dataHeaderBG {
	background-color: #263248;
}

.dataHeaderTxt {
	color: #fff;
}

.dataHeaderTxt a {
	color: #fff;
	text-decoration: underline;
}

#divLoading {
	position: absolute;
	top: 200px;
}
	
#divDialog {
	position: absolute;
	top: 200px;
}