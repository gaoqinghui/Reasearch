s1_M = timeseries([11.8;41.1;39.7;48.9;35.8;73.1;185;159.4;49.1;14.5;33.7;3.8;3.7;0.3;43.7;58.2;94.6;77.9;168.4;21.6;39.7;29.5;4.7;11.7;1.8;0;10.3;0.9;53.3;40.2;59.2;215.7;24.3;24.5;10.9;0;5.5;3.5;1.4;9.3;16.9;35.8;60.9;153.9;59.3;9.1;65.1;0;0.1;7.4;1.2;17.6;28.8;88.7;169.9;80.8;6.3;28.9;31.1;14.3;0;3.5;3.3;19.3;17.4;97.6;187.5;217.5;126;10.5;5.7;0;2.5;0.2;4.8;30.1;9.5;65.8;388.7;542.7;19;31.7;2;0.1;0.4;8.8;48.6;18.2;20.5;32.3;65.5;57.3;46.7;2.2;15.4;12.9;12.3;17.4;18.2;33.6;74.4;8.5;79.4;66.9;3.8;56.2;0.7;3.3;0;0;0.9;10.3;40.4;27.6;131.9;248.9;28.8;20.5;9;0;19.2;0.3;1.7;22.9;41;299.4;44.1;92;68.5;6.8;17.9;15.6;1.5;21.1;7.9;31.2;63.9;97.3;22.6;11.7;10.7;1.8;0.6;5.7;24.8;40.6;111.3;87.1;47.9;67;38.3;24.1;2.6;2.9;17.3;56.9;103.5;27.9;131.5;115.9;37.4;94.7;50.4;0.1;2.3;13.7;40.6;17.6;129.2;186.1;67.7;39.4;2.5;1.3;21.8;1.9;15.5;0.2;11.2;39.6;43.3;89.7;101.7;83.6;2;0.8;4.1;0.4;0;16.5;58.6;38.2;139.5;111.7;14.9;0.5;18.1;5.3;3.8;54.6;1.2;55.6;68.5;48.2;84;63.9;47.1;3.5;8;22.1;47.9;31.5;97.1;129.2;238.6;116.4;16.6;0.2;0.1;10.2;5.5;7;47.1;49.1;67.1;288.2;119.2;11.1;94.4;1.2;12;16.1;15.7;19.3;15.7;75.8;155.3;109.6;10.4;1.8;13.5;0.2;6.4;36.1;63.2;157.7;230.2;113.2;14.6;36.6;2.5;1.1;7.8;64.4;19.4;103.1;207.4;107;98.4;6.5;25.7;8.6;8.4;4.7;2.4;27.7;18.3;97.9;168.7;59.9;108.9;7.9;3.5;7;0.9;24.9;28.7;38.7;80.9;12.3;86.6;14.8;1.1;7.6;5.7;24.7;56;33.3;57.1;171;101.8;22.2;52.8;1.2], {'01/01/1990','02/01/1990','03/01/1990','04/01/1990','05/01/1990','06/01/1990','07/01/1990','08/01/1990','09/01/1990','10/01/1990','11/01/1990','12/01/1990','01/01/1991','02/01/1991','03/01/1991','04/01/1991','05/01/1991','06/01/1991','07/01/1991','08/01/1991','09/01/1991','10/01/1991','11/01/1991','12/01/1991','01/01/1992','02/01/1992','03/01/1992','04/01/1992','05/01/1992','06/01/1992','07/01/1992','08/01/1992','09/01/1992','10/01/1992','11/01/1992','12/01/1992','01/01/1993','02/01/1993','03/01/1993','04/01/1993','05/01/1993','06/01/1993','07/01/1993','08/01/1993','09/01/1993','10/01/1993','11/01/1993','12/01/1993','01/01/1994','02/01/1994','03/01/1994','04/01/1994','05/01/1994','06/01/1994','07/01/1994','08/01/1994','09/01/1994','10/01/1994','11/01/1994','12/01/1994','01/01/1995','02/01/1995','03/01/1995','04/01/1995','05/01/1995','06/01/1995','07/01/1995','08/01/1995','09/01/1995','10/01/1995','11/01/1995','12/01/1995','01/01/1996','02/01/1996','03/01/1996','04/01/1996','05/01/1996','06/01/1996','07/01/1996','08/01/1996','09/01/1996','10/01/1996','11/01/1996','12/01/1996','01/01/1997','02/01/1997','03/01/1997','04/01/1997','05/01/1997','06/01/1997','07/01/1997','08/01/1997','09/01/1997','10/01/1997','11/01/1997','12/01/1997','01/01/1998','02/01/1998','03/01/1998','04/01/1998','05/01/1998','06/01/1998','07/01/1998','08/01/1998','09/01/1998','10/01/1998','11/01/1998','12/01/1998','01/01/1999','02/01/1999','03/01/1999','04/01/1999','05/01/1999','06/01/1999','07/01/1999','08/01/1999','09/01/1999','10/01/1999','11/01/1999','12/01/1999','01/01/2000','03/01/2000','04/01/2000','05/01/2000','06/01/2000','07/01/2000','08/01/2000','09/01/2000','10/01/2000','11/01/2000','01/01/2001','02/01/2001','03/01/2001','04/01/2001','05/01/2001','06/01/2001','07/01/2001','08/01/2001','09/01/2001','10/01/2001','11/01/2001','12/01/2001','01/01/2002','03/01/2002','04/01/2002','05/01/2002','06/01/2002','07/01/2002','08/01/2002','09/01/2002','10/01/2002','12/01/2002','01/01/2003','02/01/2003','03/01/2003','04/01/2003','05/01/2003','06/01/2003','07/01/2003','08/01/2003','09/01/2003','10/01/2003','11/01/2003','12/01/2003','01/01/2004','02/01/2004','04/01/2004','05/01/2004','06/01/2004','07/01/2004','08/01/2004','09/01/2004','10/01/2004','11/01/2004','12/01/2004','01/01/2005','02/01/2005','03/01/2005','04/01/2005','05/01/2005','06/01/2005','07/01/2005','08/01/2005','09/01/2005','10/01/2005','12/01/2005','01/01/2006','02/01/2006','03/01/2006','04/01/2006','05/01/2006','06/01/2006','07/01/2006','08/01/2006','09/01/2006','10/01/2006','11/01/2006','12/01/2006','02/01/2007','03/01/2007','04/01/2007','05/01/2007','06/01/2007','07/01/2007','08/01/2007','09/01/2007','10/01/2007','12/01/2007','01/01/2008','03/01/2008','04/01/2008','05/01/2008','06/01/2008','07/01/2008','08/01/2008','09/01/2008','10/01/2008','11/01/2008','12/01/2008','02/01/2009','03/01/2009','04/01/2009','05/01/2009','06/01/2009','07/01/2009','08/01/2009','09/01/2009','10/01/2009','11/01/2009','01/01/2010','02/01/2010','03/01/2010','04/01/2010','05/01/2010','06/01/2010','07/01/2010','08/01/2010','09/01/2010','10/01/2010','12/01/2010','02/01/2011','03/01/2011','04/01/2011','05/01/2011','06/01/2011','07/01/2011','08/01/2011','09/01/2011','10/01/2011','11/01/2011','12/01/2011','01/01/2012','03/01/2012','04/01/2012','05/01/2012','06/01/2012','07/01/2012','08/01/2012','09/01/2012','10/01/2012','11/01/2012','12/01/2012','01/01/2013','02/01/2013','03/01/2013','04/01/2013','05/01/2013','06/01/2013','07/01/2013','08/01/2013','09/01/2013','10/01/2013','11/01/2013','02/01/2014','03/01/2014','04/01/2014','05/01/2014','06/01/2014','07/01/2014','08/01/2014','09/01/2014','10/01/2014','01/01/2015','02/01/2015','03/01/2015','04/01/2015','05/01/2015','06/01/2015','07/01/2015','08/01/2015','09/01/2015','10/01/2015','11/01/2015','12/01/2015'});
s1_M.Name = 'CN: Precipitation: Hebei: Shijiazhuang';
s1_M.TimeInfo.Format = 'mm/dd/yyyy';
s1_M.UserData.seriesInfo = struct('seriesId','318976201','srCode','SR5677819','country','China','seriesName','CN: Precipitation: Hebei: Shijiazhuang','nameLocal','','Unit','mm','frequency','Monthly','source','Meteorological Administration','firstObsDate','01/01/1990','LastObsDate','12/01/2015','multiplierCode','NA','tLastUpdTime','04/24/2017','seriesStatus','Active','remarks','','functionInformation','""');
s2_M = timeseries([24.3;65.2;95.9;39.4;65.8;181;101.2;120.2;55.1;0.9;46.4;5;7.6;11.6;64.9;21.5;97;62.4;70.5;65.2;39.8;2.8;21.1;10.7;0.7;2.6;31.1;17.1;147.9;39.3;109.8;138.5;153.4;13.1;10.7;14.9;16;18.2;19.9;82.5;31.5;97.4;51.1;93.5;33.1;35;80.4;0;2.6;6.7;16.5;98.1;42.4;188.2;193.6;54.2;5.4;60.4;34.9;15.9;0;0;17.3;13.5;12.5;41.9;206.9;153.7;11.3;88;2.2;1.3;1;17.7;13.7;35.1;17.6;15.3;133.5;186.7;126.6;49.5;31.6;7.7;13.6;42.2;28.7;73.6;19.2;14.6;33.5;77.9;2.3;37.1;4.5;9.9;24;64.3;39.1;167.6;29.4;248.8;186.3;0.6;7.4;0.5;3.9;0;0;34.8;37.7;31.2;28.5;230.7;94.3;104;73.3;5.7;0;26.3;1.8;8.6;20.1;43.5;243.1;88.2;105;73.5;22.1;4.9;42.1;20.1;1.6;8.2;0.6;75.2;97.4;65.8;14.9;37.6;0.5;37.8;10.8;25.2;27.6;116.8;106.7;95.8;148.9;49.1;18.3;2.9;26.6;7.5;24.9;32.7;17.7;36.7;149.9;119.2;313.2;125.9;132.4;34.5;16;2.1;17.7;5.3;11.8;78.8;106.6;264.5;121.7;100.2;3.9;40.1;14.7;8.3;9.6;13.3;56.5;132.9;214.4;118;133.3;35.3;4.9;2.3;25.8;17.8;5.4;37;65.5;82.9;181.9;162.1;50;58.7;5.5;13.6;64.4;15.8;24.7;55.9;152.9;228.5;4.6;18.6;9;8.4;17;2.5;2;90.8;59.4;24.6;309.7;58.5;64.4;13.3;12.9;3.1;30.1;17.3;49.2;82.9;49.8;125.2;270.2;80.4;9.6;46.7;1.1;0.2;13.2;15.4;54.6;21.6;18.7;152.6;178.6;141.1;2.8;1.5;27.1;2.8;15.5;35.7;3.6;69.2;137;253.4;39.2;117.2;5.8;1.8;16.9;53.3;12.4;7.2;89.1;174.1;105.2;18;11.6;9.1;5.2;8;6.5;28.2;112.5;15.2;45.1;63.9;9.8;26.3;32.5;0.1;24.3;6.9;56.4;57.6;27.5;50.3;67.7;228;15.1;17.6;0.1;13.1;1.1;16;79.1;82.3;108.2;83.7;142.6;19.8;63.7;78.5;1], {'01/01/1990','02/01/1990','03/01/1990','04/01/1990','05/01/1990','06/01/1990','07/01/1990','08/01/1990','09/01/1990','10/01/1990','11/01/1990','12/01/1990','01/01/1991','02/01/1991','03/01/1991','04/01/1991','05/01/1991','06/01/1991','07/01/1991','08/01/1991','09/01/1991','10/01/1991','11/01/1991','12/01/1991','01/01/1992','02/01/1992','03/01/1992','04/01/1992','05/01/1992','06/01/1992','07/01/1992','08/01/1992','09/01/1992','10/01/1992','11/01/1992','12/01/1992','01/01/1993','02/01/1993','03/01/1993','04/01/1993','05/01/1993','06/01/1993','07/01/1993','08/01/1993','09/01/1993','10/01/1993','11/01/1993','12/01/1993','01/01/1994','02/01/1994','03/01/1994','04/01/1994','05/01/1994','06/01/1994','07/01/1994','08/01/1994','09/01/1994','10/01/1994','11/01/1994','12/01/1994','01/01/1995','02/01/1995','03/01/1995','04/01/1995','05/01/1995','06/01/1995','07/01/1995','08/01/1995','09/01/1995','10/01/1995','11/01/1995','12/01/1995','01/01/1996','02/01/1996','03/01/1996','04/01/1996','05/01/1996','06/01/1996','07/01/1996','08/01/1996','09/01/1996','10/01/1996','11/01/1996','01/01/1997','02/01/1997','03/01/1997','04/01/1997','05/01/1997','06/01/1997','07/01/1997','08/01/1997','09/01/1997','10/01/1997','11/01/1997','12/01/1997','01/01/1998','02/01/1998','03/01/1998','04/01/1998','05/01/1998','06/01/1998','07/01/1998','08/01/1998','09/01/1998','10/01/1998','11/01/1998','12/01/1998','01/01/1999','02/01/1999','03/01/1999','04/01/1999','05/01/1999','06/01/1999','07/01/1999','08/01/1999','09/01/1999','10/01/1999','11/01/1999','12/01/1999','01/01/2000','02/01/2000','04/01/2000','05/01/2000','06/01/2000','07/01/2000','08/01/2000','09/01/2000','10/01/2000','11/01/2000','12/01/2000','01/01/2001','02/01/2001','03/01/2001','04/01/2001','05/01/2001','06/01/2001','07/01/2001','08/01/2001','09/01/2001','10/01/2001','11/01/2001','12/01/2001','01/01/2002','03/01/2002','04/01/2002','05/01/2002','06/01/2002','07/01/2002','08/01/2002','09/01/2002','10/01/2002','11/01/2002','12/01/2002','01/01/2003','02/01/2003','03/01/2003','04/01/2003','05/01/2003','06/01/2003','07/01/2003','08/01/2003','09/01/2003','10/01/2003','11/01/2003','12/01/2003','01/01/2004','02/01/2004','03/01/2004','04/01/2004','05/01/2004','06/01/2004','07/01/2004','08/01/2004','09/01/2004','10/01/2004','11/01/2004','12/01/2004','02/01/2005','03/01/2005','04/01/2005','05/01/2005','06/01/2005','07/01/2005','08/01/2005','09/01/2005','10/01/2005','11/01/2005','12/01/2005','01/01/2006','02/01/2006','03/01/2006','04/01/2006','05/01/2006','06/01/2006','07/01/2006','08/01/2006','09/01/2006','11/01/2006','12/01/2006','02/01/2007','03/01/2007','04/01/2007','05/01/2007','06/01/2007','07/01/2007','08/01/2007','09/01/2007','10/01/2007','11/01/2007','12/01/2007','01/01/2008','02/01/2008','03/01/2008','04/01/2008','05/01/2008','06/01/2008','07/01/2008','08/01/2008','09/01/2008','10/01/2008','11/01/2008','12/01/2008','02/01/2009','03/01/2009','04/01/2009','05/01/2009','06/01/2009','07/01/2009','08/01/2009','09/01/2009','10/01/2009','11/01/2009','12/01/2009','01/01/2010','02/01/2010','03/01/2010','04/01/2010','05/01/2010','06/01/2010','07/01/2010','08/01/2010','09/01/2010','10/01/2010','11/01/2010','02/01/2011','03/01/2011','04/01/2011','05/01/2011','06/01/2011','07/01/2011','08/01/2011','09/01/2011','10/01/2011','11/01/2011','12/01/2011','01/01/2012','03/01/2012','04/01/2012','05/01/2012','06/01/2012','07/01/2012','08/01/2012','09/01/2012','10/01/2012','11/01/2012','12/01/2012','01/01/2013','02/01/2013','03/01/2013','04/01/2013','05/01/2013','06/01/2013','07/01/2013','08/01/2013','09/01/2013','10/01/2013','11/01/2013','01/01/2014','02/01/2014','03/01/2014','04/01/2014','05/01/2014','06/01/2014','07/01/2014','08/01/2014','09/01/2014','10/01/2014','11/01/2014','12/01/2014','01/01/2015','02/01/2015','03/01/2015','04/01/2015','05/01/2015','06/01/2015','07/01/2015','08/01/2015','09/01/2015','10/01/2015','11/01/2015','12/01/2015'});
s2_M.Name = 'CN: Precipitation: Henan: Zhengzhou';
s2_M.TimeInfo.Format = 'mm/dd/yyyy';
s2_M.UserData.seriesInfo = struct('seriesId','318977501','srCode','SR5677864','country','China','seriesName','CN: Precipitation: Henan: Zhengzhou','nameLocal','','Unit','mm','frequency','Monthly','source','Meteorological Administration','firstObsDate','01/01/1990','LastObsDate','12/01/2015','multiplierCode','NA','tLastUpdTime','04/24/2017','seriesStatus','Active','remarks','','functionInformation','""');
s3_M = timeseries([103.8;95.5;176.7;228.5;232.3;227.8;150.3;226.7;169.8;234.4;140;191.7;161.6;162.8;134.1;219.8;250.6;268.8;214.4;246.5;139.5;215.3;198.1;88.8;149.9;234.1;152.4;262.5;279;262.4;249.5;171.6;223.4;193.4;176.7;106.4;123.6;178.4;197.1;233.7;239.3;246.6;201.5;205.3;237.8;207.8;113.2;162.3;140.2;106.4;191.6;211.9;276.7;214.7;187;201.9;233.6;178.1;77;47.4;181.6;139;184.4;226.3;254.3;198.5;163.2;118.7;121.9;127.3;181.9;93;96.8;231.9;209.3;216.5;281.8;249;146.8;104.5;200.2;143.5;151.2;159;145.1;174.7;169.6;244.1;270.4;252.3;238.2;258.7;216.1;268.8;87;85;143.1;152.9;140.8;166;196.6;185.4;122.6;213.1;187.5;149.1;151.6;101.3;154;206;104;213;196;236;225;217;142;173;154;184;114.3;149.6;214.6;233.6;240.1;188.5;183.6;176.7;218.1;119.2;79.3;90.2;78.7;101.2;237.8;176.7;289.5;180.5;195.5;195.9;191.6;161.8;177.3;140.8;169;188;232;203;229;128;226;263;213;231;205;17;169;110;94;131;105;158;90;197;155;215;98;203;193.8;219.2;220.9;240.9;277.9;213.4;185.4;152.1;203.4;220.7;197.5;97.9;168.4;98.5;266;250.1;247.8;203.5;144.9;170.4;168;189.9;195.4;171.2;53.5;146.4;258.7;255.4;221.6;272.9;147.7;157.6;234.7;175;155.7;149;163.7;180.5;161.8;276.7;278.4;163.2;146.1;193.6;199;141.5;157.4;105.8;109.6;227;212.6;228.3;274.7;169.2;210.5;141.4;165.6;208.3;204.5;185.8;167.5;121.4;217.5;245.2;272.2;282.1;186.8;133.1;121;209.7;157.2;161.6;147.1;104.3;162.1;212.8;294.1;266.1;193.6;195.4;177.6;173.4;235;216.2;198;105.6;273.9;273;276.5;208.5;164.8;153;173.3;165.1;92.5;117.6;105.8;169.6;190.7;244.3;233.8;200.9;178.7;195.3;228.7;246.9;180;113.5;83.6;67.9;149.2;224.1;178.9;119;138.8;219.5;113.2;106.2;173.4;143;123.2;25.4;169.9;141;232.5;130.8;115.6;135.7;82.1;90.3;132.8;206.1;149.2;170.2;222.2;225.8;243.7;174.4;115.8;199.3;152.7;203.4;32.2;115.2], {'01/01/1990','02/01/1990','03/01/1990','04/01/1990','05/01/1990','06/01/1990','07/01/1990','08/01/1990','09/01/1990','10/01/1990','11/01/1990','12/01/1990','01/01/1991','02/01/1991','03/01/1991','04/01/1991','05/01/1991','06/01/1991','07/01/1991','08/01/1991','09/01/1991','10/01/1991','11/01/1991','12/01/1991','01/01/1992','02/01/1992','03/01/1992','04/01/1992','05/01/1992','06/01/1992','07/01/1992','08/01/1992','09/01/1992','10/01/1992','11/01/1992','12/01/1992','01/01/1993','02/01/1993','03/01/1993','04/01/1993','05/01/1993','06/01/1993','07/01/1993','08/01/1993','09/01/1993','10/01/1993','11/01/1993','12/01/1993','01/01/1994','02/01/1994','03/01/1994','04/01/1994','05/01/1994','06/01/1994','07/01/1994','08/01/1994','09/01/1994','10/01/1994','11/01/1994','12/01/1994','01/01/1995','02/01/1995','03/01/1995','04/01/1995','05/01/1995','06/01/1995','07/01/1995','08/01/1995','09/01/1995','10/01/1995','11/01/1995','12/01/1995','01/01/1996','02/01/1996','03/01/1996','04/01/1996','05/01/1996','06/01/1996','07/01/1996','08/01/1996','09/01/1996','10/01/1996','11/01/1996','12/01/1996','01/01/1997','02/01/1997','03/01/1997','04/01/1997','05/01/1997','06/01/1997','07/01/1997','08/01/1997','09/01/1997','10/01/1997','11/01/1997','12/01/1997','01/01/1998','02/01/1998','03/01/1998','04/01/1998','05/01/1998','06/01/1998','07/01/1998','08/01/1998','09/01/1998','10/01/1998','11/01/1998','12/01/1998','01/01/1999','02/01/1999','03/01/1999','04/01/1999','05/01/1999','06/01/1999','07/01/1999','08/01/1999','09/01/1999','10/01/1999','11/01/1999','12/01/1999','01/01/2000','02/01/2000','03/01/2000','04/01/2000','05/01/2000','06/01/2000','07/01/2000','08/01/2000','09/01/2000','10/01/2000','11/01/2000','12/01/2000','01/01/2001','02/01/2001','03/01/2001','04/01/2001','05/01/2001','06/01/2001','07/01/2001','08/01/2001','09/01/2001','10/01/2001','11/01/2001','12/01/2001','01/01/2002','02/01/2002','03/01/2002','04/01/2002','05/01/2002','06/01/2002','07/01/2002','08/01/2002','09/01/2002','10/01/2002','11/01/2002','12/01/2002','01/01/2003','02/01/2003','03/01/2003','04/01/2003','05/01/2003','06/01/2003','07/01/2003','08/01/2003','09/01/2003','10/01/2003','11/01/2003','12/01/2003','01/01/2004','02/01/2004','03/01/2004','04/01/2004','05/01/2004','06/01/2004','07/01/2004','08/01/2004','09/01/2004','10/01/2004','11/01/2004','12/01/2004','01/01/2005','02/01/2005','03/01/2005','04/01/2005','05/01/2005','06/01/2005','07/01/2005','08/01/2005','09/01/2005','10/01/2005','11/01/2005','12/01/2005','01/01/2006','02/01/2006','03/01/2006','04/01/2006','05/01/2006','06/01/2006','07/01/2006','08/01/2006','09/01/2006','10/01/2006','11/01/2006','12/01/2006','01/01/2007','02/01/2007','03/01/2007','04/01/2007','05/01/2007','06/01/2007','07/01/2007','08/01/2007','09/01/2007','10/01/2007','11/01/2007','12/01/2007','01/01/2008','02/01/2008','03/01/2008','04/01/2008','05/01/2008','06/01/2008','07/01/2008','08/01/2008','09/01/2008','10/01/2008','11/01/2008','12/01/2008','01/01/2009','02/01/2009','03/01/2009','04/01/2009','05/01/2009','06/01/2009','07/01/2009','08/01/2009','09/01/2009','10/01/2009','11/01/2009','12/01/2009','01/01/2010','02/01/2010','03/01/2010','04/01/2010','05/01/2010','06/01/2010','07/01/2010','08/01/2010','09/01/2010','10/01/2010','11/01/2010','12/01/2010','01/01/2011','02/01/2011','03/01/2011','04/01/2011','05/01/2011','06/01/2011','07/01/2011','08/01/2011','09/01/2011','10/01/2011','11/01/2011','12/01/2011','01/01/2012','02/01/2012','03/01/2012','04/01/2012','05/01/2012','06/01/2012','07/01/2012','08/01/2012','09/01/2012','10/01/2012','11/01/2012','12/01/2012','01/01/2013','02/01/2013','03/01/2013','04/01/2013','05/01/2013','06/01/2013','07/01/2013','08/01/2013','09/01/2013','10/01/2013','11/01/2013','12/01/2013','01/01/2014','02/01/2014','03/01/2014','04/01/2014','05/01/2014','06/01/2014','07/01/2014','08/01/2014','09/01/2014','10/01/2014','11/01/2014','12/01/2014','01/01/2015','02/01/2015','03/01/2015','04/01/2015','05/01/2015','06/01/2015','07/01/2015','08/01/2015','09/01/2015','10/01/2015','11/01/2015','12/01/2015'});
s3_M.Name = 'CN: Sunshine Hours: Hebei: Shijiazhuang';
s3_M.TimeInfo.Format = 'mm/dd/yyyy';
s3_M.UserData.seriesInfo = struct('seriesId','318979301','srCode','SR5677822','country','China','seriesName','CN: Sunshine Hours: Hebei: Shijiazhuang','nameLocal','','Unit','Hour','frequency','Monthly','source','Meteorological Administration','firstObsDate','01/01/1990','LastObsDate','12/01/2015','multiplierCode','NA','tLastUpdTime','04/24/2017','seriesStatus','Active','remarks','','functionInformation','""');