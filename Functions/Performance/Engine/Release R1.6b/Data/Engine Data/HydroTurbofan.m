function RawEngineData = HydroTurbofan
%TF25Data provides raw engine data for the engine TF25 
%
% Engine data for Diversion, Climb, Descent, Cruise, Hold and Approach
%
% Source: Mr N. A. Mitchell ( January 2017)
% 
% Data provided as [altitude [ft], Mach number [-], Thrust [N], Fuel Flow [kg/hr] ]

RawEngineData.Climb = [ 
0	0.25	41255.01639	592
0	0.35	37018	599
0	0.45	33471	608
0	0.65	27726	633
10000	0.35	31051	485
10000	0.45	28390	493
10000	0.65	24148	516
10000	0.75	22554	529
20000	0.45	22519	387
20000	0.65	20104	409
20000	0.75	19104	421
20000	0.80	18654	428
20000	0.82	18461	430
20000	0.84	18268	433
25000	0.45	19104	330
25000	0.65	17628	358
25000	0.75	17005	370
25000	0.80	16731	376
25000	0.82	16603	378
25000   0.84    16473	381  
31000	0.65	14157	286
31000	0.75	14313	311
31000	0.80	14146	317
31000	0.82	14080	319
31000	0.84	14014	322
35000	0.65	11764	234
35000	0.75	11962	257
35000	0.80	12149	271
35000	0.82	12239	277
35000	0.84	12338	283
39000	0.65	9757	196
39000	0.75	9910	214
39000	0.80	10073	226
39000	0.82	10147	230
39000	0.82	10228	236];

RawEngineData.Descent = [   
0   	0.25	 488	181
0	    0.35	-215	182
0	    0.45	-1229	178
0	    0.65	-3542	198
10000	0.35	  15	145
10000	0.45	-697	143
10000	0.65	-2406	137
10000	0.75	-3425	132
20000	0.45	-240	124
20000	0.65	-1409	112
20000	0.75	-2118	110
20000	0.80	-2527	109
20000	0.82	-2474	102
25000	0.45	-12     115
25000	0.65	-942	112
25000	0.75	-1531	111
25000	0.80	-1826	109
25000	0.82	-1937	109
31000	0.65	-445	112
31000	0.75	-940	109
31000	0.80	-1173	108
31000	0.82	-1263	108
35000	0.65	-56	    118
35000	0.75	-534	111
35000	0.80	-761	109
35000	0.82	-849	108
39000	0.65	 352	126
39000	0.75	-99	    120
39000	0.80	-291	117
39000	0.82	-372	115];

RawEngineData.Cruise = [
0	0.15	1190	181
0	0.15	833 	121
0	0.15	1667	145
0	0.15	4167	217
0	0.15	8333	337
0	0.15	12500	457
0	0.15	16667	577
0	0.15	20833	697
0	0.15	28202	914
0	0.15	35252	1106
0	0.15	42310	1307
0	0.15	56415	1741
0	0.15	70515	2192
0	0.15	75820	2365

0	0.25	488     181
0	0.25	833     168
0	0.25	1667	195
0	0.25	4167	276
0	0.25	8333	411
0	0.25	12500	546
0	0.25	16667	681
0	0.25	20833	816
0	0.25	25577	966
0	0.25	31972	1160
0	0.25	38370	1360
0	0.25	51158	1787
0	0.25	63947	2224
0	0.25	68758	2393

0	0.35	-215	182
0	0.35	833     214
0	0.35	1667	244
0	0.35	4167	334
0	0.35	8333	485
0	0.35	12500	635
0	0.35	16667	785
0	0.35	20833	936
0	0.35	22953	1019
0	0.35	28691	1214
0	0.35	34429	1414
0	0.35	45902	1832
0	0.35	57378	2257
0	0.35	61697	2421

0	0.45	-1229	178
0	0.45	417     252
0	0.45	833     269
0	0.45	2083	319
0	0.45	4167	402
0	0.45	8333	568
0	0.45	12500	733
0	0.45	16667	899
0	0.45	20752	1079
0	0.45	25940	1273
0	0.45	31128	1470
0	0.45	41504	1883
0	0.45	51880	2298
0	0.45	55785	2458

0	0.65	-3542	198
0	0.65	417     386
0	0.65	833     406
0	0.65	1667	446
0	0.65	3333	525
0	0.65	5833	644
0	0.65	8333	764
0	0.65	12500	963
0	0.65	17190	1186
0	0.65	21488	1412
0	0.65	25786	1605
0	0.65	34381	1997
0	0.65	42975	2405
0	0.65	46210	2559

10000	0.35	15      145
10000	0.35	19252	797
10000	0.35	24065	957
10000	0.35	28877	1123
10000	0.35	38504	1463
10000	0.35	48129	1818
10000	0.35	51752	1958

10000	0.45	-697	143
10000	0.45	17602	842
10000	0.45	22003	1003
10000	0.45	26403	1168
10000	0.45	35205	1506
10000	0.45	44005	1856
10000	0.45	47317	1994

10000	0.6500	-2406	137
10000	0.6500	14972	951
10000	0.6500	18715	1110
10000	0.6500	22458	1271
10000	0.6500	29944	1612
10000	0.6500	37430	1955
10000	0.6500	40247	2084

10000	0.75	-3425	132
10000	0.75	13984	1016
10000	0.75	17480	1177
10000	0.75	20976	1341
10000	0.75	27968	1673
10000	0.75	34960	2007
10000	0.75	37591	2136

20000	0.45	-240	124
20000	0.45	20943	880
20000	0.45	24433	1007
20000	0.45	27924	1140
20000	0.45	31414	1277
20000	0.45	34905	1426
20000	0.45	37532	1565

20000	0.65	-1409	112
20000	0.65	18696	983
20000	0.65	21812	1120
20000	0.65	24928	1256
20000	0.65	28044	1393
20000	0.65	31160	1536
20000	0.65	33506	1651

20000	0.75	-2118	110
20000	0.75	17767	1036
20000	0.75	20728	1171
20000	0.75	23689	1308
20000	0.75	26650	1447
20000	0.75	29611	1588
20000	0.75	31840	1701

20000	0.80	-2527	109
20000	0.80	17348	1061
20000	0.80	20239	1198
20000	0.80	23130	1335
20000	0.80	26022	1475
20000	0.80	28913	1618
20000	0.80	31089	1728

20000	0.82	-2474	102
20000	0.82	16096	1003
20000	0.82	18779	1132
20000	0.82	21462	1261
20000	0.82	24143	1393
20000	0.82	26827	1527
20000	0.82	28845	1629

25000	0.45	-12     115
25000	0.45	17792	734
25000	0.45	20758	841
25000	0.45	23723	953
25000	0.45	26688	1070
25000	0.45	29654	1207
25000	0.45	31840	1335

25000	0.65	-942	112
25000	0.65	16394	839
25000	0.65	19127	956
25000	0.65	21859	1073
25000	0.65	24592	1193
25000	0.65	27324	1324
25000	0.65	29381	1445

25000	0.75	-1531	111
25000	0.75	15815	891
25000	0.75	18451	1009
25000	0.75	21086	1129
25000	0.75	23722	1252
25000	0.75	26358	1382
25000	0.75	28342	1494

25000	0.80	-1826	109
25000	0.80	15560	917
25000	0.80	18154	1036
25000	0.80	20747	1159
25000	0.80	23341	1284
25000	0.80	25934	1414
25000	0.80	27886	1519

25000	0.82	-1937	109
25000	0.82	15441	926
25000	0.82	18014	1046
25000	0.82	20588	1170
25000	0.82	23161	1295
25000	0.82	25734	1425
25000	0.82	27671	1529

31000	0.65	-445	112
31000	0.65	13193	662
31000	0.65	15392	752
31000	0.65	16492	798
31000	0.65	17591	845
31000	0.65	18690	892
31000	0.65	19790	942
31000	0.65	21989	1057
31000	0.65	23595	1154

31000	0.75	-940	109
31000	0.75	13311	725
31000	0.75	15529	823
31000	0.75	16639	873
31000	0.75	17748	923
31000	0.75	18857	974
31000	0.75	19966	1028
31000	0.75	22185	1152
31000	0.75	23855	1257

31000	0.8     -1173	108
31000	0.8     13156	747
31000	0.8     15348	847
31000	0.8 	16445	898
31000	0.8     17541	950
31000	0.8     18637	1001
31000	0.8     19733	1056
31000	0.8     21926	1176
31000	0.8     23576	1280

31000	0.82	-1263	108
31000	0.82	13095	756
31000	0.82	15277	857
31000	0.82	16368	909
31000	0.82	17460	961
31000	0.82	18551	1013
31000	0.82	19642	1067
31000	0.82	21825	1185
31000	0.82	23467	1290

35000	0.65	-56     118
35000	0.65	10966	547
35000	0.65	12794	621
35000	0.65	13708	657
35000	0.65	14622	695
35000	0.65	15535	734
35000	0.65	16449	774
35000	0.65	18277	868
35000	0.65	19607	947

35000	0.75	-534	111
35000	0.75	11152	602
35000	0.75	13011	681
35000	0.75	13941	722
35000	0.75	14870	764
35000	0.75	15799	806
35000	0.75	16728	851
35000	0.75	18587	954
35000	0.75	19936	1038

35000	0.80	-761	109
35000	0.80	11329	633
35000	0.80	13217	717
35000	0.80	14161	761
35000	0.80	15105	804
35000	0.80	16049	849
35000	0.80	16993	897
35000	0.80	18882	1006
35000	0.80	20248	1094

35000	0.82	-849	108
35000	0.82	11415	647
35000	0.82	13318	733
35000	0.82	14269	777
35000	0.82	15221	822
35000	0.82	16172	868
35000	0.82	17123	916
35000	0.82	19026	1028
35000	0.82	20398	1118

39000	0.65	352     126	
39000	0.65	9097	459	
39000	0.65	10613	520	
39000	0.65	11371	551	
39000	0.65	12129	583	
39000	0.65	12887	614	
39000	0.65	13645	648	
39000	0.65	15161	727	
39000	0.65	16262	792	

39000	0.75	-99     120
39000	0.75	9235	504
39000	0.75	10777	571
39000	0.75	11548	605
39000	0.75	12318	639
39000	0.75	13089	674
39000	0.75	13860	711
39000	0.75	15402	797
39000	0.75	16517	867

39000	0.80	-291	117
39000	0.80	9396	531
39000	0.80	10962	601
39000	0.80	11745	637
39000	0.80	12528	673
39000	0.80	13311	710
39000	0.80	14094	749
39000	0.80	15660	839
39000	0.80	16788	912

39000	0.82	-372	115
39000	0.82	9466	542
39000	0.82	11044	614
39000	0.82	11833	650
39000	0.82	12622	687
39000	0.82	13410	725
39000	0.82	14200	765
39000	0.82	15777	857
39000	0.82	16911	931];


RawEngineData.Hold = RawEngineData.Cruise;

RawEngineData.Diversion = RawEngineData.Cruise;
end
