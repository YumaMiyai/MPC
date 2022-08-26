function [A, B, Aeq, Beq, Lb, Ub] = Constraints(x0,i)
    global horizon;
    global lb; global ub;
    
    A = [];
    B = [];
    Aeq = [];
    Beq = [];
    %Lb = -100 * ones(input_size* horizon, 1);
    %Ub = 200 * ones(input_size* horizon, 1);
    Lb=[];
    Ub=[];
    for w=1:horizon
        Lb=[Lb;lb];
        Ub=[Ub;ub];
    end
end