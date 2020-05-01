% Calculates Drug Grade given a column vector of FV values at different doses or times; and a equal
% length column vector of GR values at the same doses or times.
function GRADE = calcGRADE(GR,FV,tau,x)

[r c] = size(GR);
[r2,c2] = size(FV);

if c ~= c2
    error('FV and GR must have same number of columns')
    return;
elseif r ~= r2
    error('FV and GR must have same length')
    return;
end

range = GR>0 & GR<=1;
GR = [1;GR(range)];
FV = [1;FV(range)];

    if min(GR)> .9
        
        GRADE = NaN;
        
 elseif length(GR)<2
    GRADE = NaN;
    
GR = GR./(max(GR));
FV = FV./(max(FV));

else
Line = fit(GR,FV,'poly1');
Md = atan(Line.p1); % angle of drug in radians

% tau = 26.3868; %growth rate
% x = 72; %length of assay
init = 100; %initial population size
drc = 0;  %assumption of uniform death rate for control

drd = linspace(0,1,1000)'; %vector of death rates for different doses of drug

LiveCellsControl = init*(2.^(x./tau));
DeadCellsControl = init*(2.^(x./tau))*drc;

LiveCellsDrug = init*(2.^(x./tau)) - init*(2.^(x./tau))*drd;
DeadCellsDrug = init*(2.^(x./tau))*drd;

FVmax = 1- (DeadCellsDrug./ (LiveCellsDrug+DeadCellsDrug));
GRmax = 2.^(log2(LiveCellsDrug/init)./log2(LiveCellsControl/init))-1;

rangemax = GRmax>0;
GRmax = GRmax(rangemax);
FVmax = FVmax(rangemax);

LineMax = fit(GRmax,FVmax,'poly1');
Mmax = atan(LineMax.p1); % angle of drug in radians

GRADE = Md/Mmax*100;
end