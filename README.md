# GRADE
Calculation of drug GRADEs

# Data preparation

•	Before using the calcGRADE function, fractional viability (FV) and the normalized growth rate inhibition (GR) value needs to be calculated for each dose point of a given drug. 

•	FV can be calculated by dividing the living number of cells by the total number of cells in treatment wells (more   information in materials and methods and figure 1).  FV values can be normalized to the vehicle control if basal cell death is high (this is not necessary for low basal cell death)

•	GR values are calculated as described in Hafner et al. 2016 

•	If GR values are >> 1 for untreated cells, this is likely due to plating biases in the experimental data and these should be appropriately normalized prior to calculation of drug GRADE.

# calcGRADE structure

    calcGRADE(GR,FV,tau,x)

GR – Growth rate index values for each dose

FV – Fractional viability values for each dose

tau – cell growth rate (doubling time, in hours)

x – assay duration (in hours)

# Running calcGRADE

•	FV and GR values should be stored in separate variables as a column vector that are equal lengths.  Corresponding rows in the GR and FV vectors must be the same dose point.  Replicate doses do not need to be averaged and can be included as another row in the vector.  Doses do not need to be in sequential order:
 
(Example data format for GR and FV, see supplied examples and README.docx  Each row represents the FV/GR value for a given dose)

•	To calculate GRADE, call the function calcGRADE:
        
       GRADE = calcGRADE(GR,FV,tau,x)

•	To run the supplied example data (README-ex1.mat) for a cell line with a 26 hour doubling time and an assay length of 72 hours:

      load README-ex1.mat;

       GRADE = calcGRADE(gr1,fv1,26,72);

•	This should yield a drug GRADE:

       GRADE = 27.7889

•	calcGRADE takes the vectors GR and FV in addition to the growth rate (tau), and assay length (x). All 4 inputs are required for GRADE to run properly. The function returns GRADE for the drug of interest

•	calcGRADE calculates GRADE using doses that are less than or equal to the GR50 value (GR values between 0-1).  The function solves for θdrug and θmax to determine GRADE as outlined in the schematic below (see also Schwartz et al. 2020, Figure 4A, and README.docx):
 
# Calculating GRADE for multiple drugs:

•	To calculate GRADE for multiple drugs:

•	Using cell arrays – Data for multiple drugs can be stored in a cell array (one for FV and one for GR).  Each cell in the cell array should contain a single drug’s FV or GR column vector.
 
(Example FV cell array for 3 drugs. See supplied example 2 and README.docx. An identical cell array would be created for GR)

The cell arrays for FV and GR can then be used to calculate GRADE using the built in MATLAB function cellfun:

     GRADE = cellfun(@(x,y) calcGRADE(x,y,tau,x), GR, FV)

o	The variable returned will be a vector equal to the size of the input cell array (3 in the example above) and contain the GRADE for each drug.  

•	To run the supplied example data (README-ex2.mat) for a cell line with a doubling time of 26 hours and an assay length of 72 hours:

      load README-ex2.mat;

      GRADE = cellfun(@(x,y) calcGRADE(x,y,26,72), GR, FV)

This should yield for the 3 drugs in the example

      GRADE = 

           27.7889	61.4905	2.2808

