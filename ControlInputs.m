function ControlCombination = ControlInputs(x1,x2,x3);

[F,A,C]=ndgrid(x1,x2,x3);

ControlCombination = [F(:),A(:),C(:)];

end