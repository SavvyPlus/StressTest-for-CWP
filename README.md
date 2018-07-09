# StressTest-for-CWP

## Background 

We need to perform a stress test for CWP Renewables for their wind farm in NSW. The spot price may be adjusted up to the maximum of $14,200/MWh and the Cumulative Price Threshold (sum of spot prices for the previous 7 days) cannot exceed the maximum (7.5 x $14,200 = $106500). Under these situations, we derive the weekly revenue payments for 2019 simulations with wind generation in Sapphire Wind Farm.

There are a set of wind farm and correlated spot prices simulations (3 scenarios), which have been built by previous analytics James Cheong. In this case, we are focused on the middle growth scenario which had 300 simulations. 

The simulation data can be found at 
>T:\Weiliang Zhou\HH_Sim_Spot_1000_NSW1_2018-04-21.mat 

## Methodology

### The Mathematical Model

The purpose of the stress test is to evaluate how worse the revenue can be under the situation that spot prices are adjusted up to the maximum of $14,200/MWh. The idea is to transform the Stress Test to a mathematical problem which can be solved using linear programming approach. The problem can be set up as:

**To minimise revenue (Objective function)**

**Subject to:**

**a. Spot price may be adjusted up to the maximum of $14,200/MWh.**

**b. The spot price adjustment cannot be negative.**

**c. The Cumulative Price Threshold cannot exceed the maximum where the initial starting value for the CPT is $80\*336=$26880.**

The problem can be solved using [linprog](https://au.mathworks.com/help/optim/ug/linprog.html) from Optimization Toolbox in MATLAB. 

### Functions and Scripts

**lpfunction.m** is the function to construct the vectors or matrices of objective function and constraints, and to solve the linear programming problems. The input parameters are `wind_gen (MW)`, `mlf`, `Flat Swap Sold (MW)`, `spot_prices ($/MWh)`. The return value is the adjustment to the spot prices of each half hour.

**StressTestMain.m** is the script to load input simulation data of wind generation and spot prices, and loop over 300 simulations with 6 hedging scenarios and 2 spot price scenarios. Then it calculates the net revenue of each half hour, weekly revenue, and rolling 4 weeks revenue (monthly revenue).

**WriteExcel.m** is the script to write above output data into excel for review and reporting.

### The Calculation of Revenues

The net revenue consists of `Spot Revenue`, `Fixed Block Revenue`, `PPA Revenue`. Simple sum.

1. Spot Revenue = spot price × wind generation ÷ 2 × mlf 
2. Fixed Block Revenue = (spot price − sold swap price) × flat swap sold ÷ 2
3. PPA Revenue = (spot price - PPA price) × (-PPAMW/273) × wind generation ÷ 2
