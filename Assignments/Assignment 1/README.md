# INF5870-Energy-Informatics
Energy Informatics assignments course work, assignments and reports.

# Assignment 1: Use appliances intelligently at your home

# General Consideration
Assignment 1 concentrates on demand response. The work to undertake involves a bit of
mathematical modelling, implementation in your favorite programming language
Python/Java/R/Matlab/etc.), generation and discussion of results, as well as presentation of
the work in a short report.

The expected outcome of Assignment 1 includes:
- a report
- code pasted in the appendix of the report; or as supplementary material

Assignment 1 is to be performed in groups, where a group can consist of 4 students.
The evaluation of Assignment 1 will count for 15% of the grade. All students in the same
group receive the same grade.

# Description of the Assignment
Each household has combination of the following appliances. Typical appliances included for
the purpose of Illustration. In practice, households may have a variety of other appliances.

The daily consumption of each household is divided into a 24-slot time-frame with each slot
corresponding to an hour period.

Appliances with strict consumption scheduling (non-shiftable appliances) in each household
- Lighting: (daily usage for standard bulbs: 1.00-2.00 kWh from 10:00 - 20:00),
- Heating: (daily usage: 6.4-9.6 kWh including floor heating)
- Refrigerator- freezer (daily usage: 1.32-3.96 kWh, depending on the number of
  refrigerators in the house; Consumption for 1 refrigerator including freezer=1.32 KWh)
- Electric stove (daily usage: 3.9 kWh)
- TV: (daily usage: 0.15-0.6 KWh depending on the TV size @ 5hours of use per day)
- Computer including desktop(s), laptop(s) (Number: 1-3; daily 0.6KWh per day per computer)

Consumption of shiftable appliances
- Dishwasher: (daily usage: 1.44 kWh)
- Laundry machine: (daily usage: 1.94 kWh)
- Cloth dryer: (daily usage: 2.50 kWh)
- Electric Vehicle (EV): (daily usage: 9.9 kWh)

Typical consumption values refer to [1], [2], with slight variations for different appliances. In
a residential area, without any intelligent scheduling, the power demand is usually light-tomoderate
during mornings, higher during evenings and low during nights. Considering this,
we need to assign the time slots in hours as required for the non-shiftable appliances, and
provide a range of possible time slots for operating the shiftable appliances.

1. We have a simple household that only has three appliances: a washing machine, an EV
and a dishwasher. We assume the time-of-Use (ToU) pricing scheme: 1NOK/KWh for
peak hour and 0.5NOK/KWh for off-peak hours. Peak hours are in the range of 5:00pm8:00pm
while all other timeslots are off-peak hours. Design the strategy to use these
appliances to have minimum energy cost.
Note: We need a strategy, not just the amount of the minimal energy cost. For example,
you may need to consider some exemplary questions. Is it reasonable to use all three
appliances at the same time, e.g., 2:00am which has the low energy price? How should
we distribute the power load more reasonably in the timeline?


2. We have a household with all non-shiftable appliances and all shiftable appliances (see
the two lists aforementioned). In addition to these, please choose a random combination
of appliances such as coffee maker, ceiling fan, hair dryer, toaster, microwave, router,
cellphone charger, cloth iron, separate freezer(s), etc., for the household. Please refer to
[2] to add typical energy consumption values for the appliances. Please use Real-Time
Pricing (RTP) scheme. The RTP model is followed: using a random function to generate
the pricing curve in a day. The pricing curve should consider higher price in the peakhours
and lower price in the off-peak hours. Compute the best strategy to schedule the
use of the appliances and write a program in order to minimize energy cost.


3. We consider a small neighborhood that has 30 households. Each household has the same
setting as that in question 2. But, we assume that only a fraction of the households owns
an EV. Please use Real-Time Pricing (RTP) scheme: using random function to generate the
pricing curve in a day. The pricing curve should consider higher price in the peak-hours
and lower price in the off-peak hours. Compute the best strategy for scheduling the
appliances and write a program in order to minimize energy cost in the neighborhood.

# Structure and contents of the report to be delivered
The report for the assignment should include:

- Question 1, calculate the minimal energy consumption and explain the main
considerations to the developed strategy.

-  Question 2, the formulation of the demand response as an optimization problem, e.g.,
linear programming problem. Please use a figure to show the pricing curve. Please
explain on how the problem is solved and probably draw the flowchart to illustrate the
main algorithm(s).

-  Question 3, the formulation of the demand response as an optimization problem. Please
use a figure to show the pricing curve. Please explain how the problem is solved and you
may draw the flowchart to illustrate the main algorithms.

- A short analysis of two different pricing schemes (ToU and RTP) impact on the energy
cost

- The code in an Appendix (if not provided separately)


# Delivery of the Assignment
Assignment 1 is to be sent to the following email
Email: yanzhang@ifi.uio.no and hweiminc@ifi.uio.no
Submission form: the submission should be in a ZIP file with naming convention 
“INF5870-Assignment1 - GroupX.zip", where “X” is the group number.
Email subject: “[INF5870] Assignment 1 submission by Group X”
Firm deadline: 20 March 2018 (whole day included)
Questions? please contact HweiMing Chung. Email: hweiminc@ifi.uio.no; office: 4161
References
[1] Office of Energy Efficiency, Natural Resources Canada, Energy Consumption of Household
Appliances Shipped in Canada Dec. 2005
[2] http://energyusecalculator.com/
