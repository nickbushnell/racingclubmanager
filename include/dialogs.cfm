<div id="overlay" style="position:absolute;top:0px;left:0px;z-index:2999;background-color:black;opacity:.80;filter: alpha(opacity=80);display:none;">
&nbsp;
</div>

<div id="divLoading" align="center" style="z-index:3000;width: 100%;display: none;">
	<div style="width: 400px; border: 2px solid #ccc; background-color: white;">
		<table width="100%">
			<tr>
				<td height="75" valign="middle" align="center">
					<div style="width: 100%;color:#000;" id="loadingTxt">Loading...</span>
				</td>
			</tr>
		</table>
	</div>
</div>

<div id="clubSearchDiv" align="center" style="width:100%; position:absolute; top: 100px; z-index:3000; display:none;">
	<table border="0" cellspacing="0" cellpadding="0" style="border: 2px solid #ccc;">
		<tr>
			<td style="background-color: #263248;" align="right">
				<a href="javascript:showClubSearch(false);" style="color:white;">Close</a>&nbsp;
			</td>
		</tr>
		<tr>
			<td><!-- style="background-color: white;" -->
				<iframe src="club_search_white.cfm" width="550" height="250" frameborder="0" id="iframe_clubSearch"></iframe>
			</td>
		</tr>

	</table>
</div>

<div id="divDialog" align="center" style="z-index:3000;width: 100%;display: none; position:absolute; top: 100px;">
	<table border="0" id="tblDialog" style="background-color: white;width:700px;border: 2px solid #ccc;" cellspacing="0" cellpadding="0">
		<tr class="dataHeaderBG">
			<td width="10%">&nbsp;</td>
			<td align="center" width="80%" class="dataHeaderTxt">
				<b><span id="spanDialogName">Edit Admins</span></b>
			</td>
			<td align="right" width="10%">
				<a href="#" id="linkDialogClose" style="color:white;">Close</a>
			</td>
		</tr>
		<tr>
			<td id="editRacers" colspan="3">
				<iframe src="" id="frameDialog" name="frameDialog" style="width:100%;height:250px;border:none;"></iframe>
			</td>
		</tr>
	</table>
</div>