-- ExelResults{Sheet=Operator1;Cell=A2}

SELECT * 
FROM vDataCDR2018_Operator1_TDG
--where Type_of_Test not like '%transfer%'										-- all without transfer
--where Type_of_Test like '%transfer%' and test_name = 'FDFS http DL ST'		-- only filebased DL
--where Type_of_Test like '%transfer%' and test_name = 'FDFS http UL ST'		-- only filebased UL
--where Type_of_Test like '%transfer%' and test_name = 'FDTT http DL MT'		-- only timebased/capacity DL
--where Type_of_Test like '%transfer%' and test_name = 'FDTT http UL MT'		-- only timebased/capacity UL

--where Type_of_Test like '%Application%'										-- only application
--where Type_of_Test like '%browser%' 											-- only browser
--where Type_of_Test like '%VideoStreaming%' and test_name = 'YouTube'			-- only streaming
where Test_Result not like 'completed' 

ORDER BY [Test_Start_Time]
