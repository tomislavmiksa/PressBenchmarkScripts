-- ExelResults{Sheet=Lists;Cell=A3}
SELECT   rnk
		,Year
		,Week
		,Month
		,Day
		,Hour
		,Call_Status
		,DialedNumber
		,System_A
		,UE_A
		,Channel_A
		,IMEI_A
		,IMSI_A
		,L1_callMode_A
		,L2_callMode_A
		,System_B
		,UE_B
		,Channel_B
		,IMEI_B
		,IMSI_B
		,L1_callMode_B
		,L2_callMode_B
		,G_Level_1_A
		,G_Level_2_A
		,G_Level_3_A
		,G_Level_4_A
		,G_Level_5_A
		,NULL as Region_A
		,NULL as Vendor_A
 FROM NEW_SELECTIONLIST_2018_TDG_Voice 
 ORDER BY rnk



