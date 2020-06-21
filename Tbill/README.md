## US Treasury Bill term structure modeling files

* `w-gs1yr.txt`: dataset consists of 1735 weekly observations of the yields of the three-month US Treasury Bill from the secondary market rates, taken from January 5, 1962 to March 31, 1995.

* `tbill_data.m`: read `w-gs1yr.txt` and convert it to a MATLAB binary.

* `tbill_joint.m`: analyze the Tbill data and estimate the Sharpe ratio functions using the proposed joint estimation method.

* `tbill_plot.R`: collect the results from `tbill_joint.m`, also apply the method of Fan and Yao (1998), and that of Wang, Brown, Cai, and Levine (2008) to generate plots.

