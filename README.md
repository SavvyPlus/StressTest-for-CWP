# StressTest-for-CWP

## Background 

We need to perform a stress test for CWP Renewables for their wind farm in NSW. The spot price may be adjusted up to the maximum of $14,200/MWh and the Cumulative Price Threshold (sum of spot prices for the previous 7 days) cannot exceed the maximum (7.5 x $14,200 = $106500). Under these situations, we derive the weekly revenue payments for 2019 simulations with wind generation in Sapphire Wind Farm.

There are a set of wind farm and correlated spot prices simulations (3 scenarios), which have been built by previous analytics James Cheong. In this case, we are focused on the middle growth scenario which had 300 simulations. 

The simulation data can be found at 
>T:\Weiliang Zhou\HH_Sim_Spot_1000_NSW1_2018-04-21.mat 

## Methodology

The purpose of the stress test is to evaluate how worse the revenue can be under the situation that spot prices are adjusted up to the maximum of $14,200/MWh. The stress test can be transformed to a mathematical problem which can be solved using linear programming approach. The problem can be set up as:

**To minimise revenue (Objective function)**

**Subject to:**

**a. Spot price may be adjusted up to the maximum of $14,200/MWh.**

**b. The spot price adjustment cannnot be negative.**

**c. The Cumulative Price Threshold cannot exceed the maximum where the initial starting value for the CPT is $80\*336=$26880.**
