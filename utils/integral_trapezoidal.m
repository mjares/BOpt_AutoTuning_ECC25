function integral = integral_trapezoidal(x, t)
%INTEGRAL_TRAPEZOIDAL Calculate numeric integral using trapezoidal method.
% Given a sampled function 'x' and a sampling time 't', this function
% produces the numerical integral of the function using the trapezoidal
% mehtod.
%   Parameters:
%   -----------
%   x : (double vector) with the function evaluations f(t).
%   t : (double vector) with the evaluation timestamps
%   
%   Return:
%   -------
%   integral : (double) numerical integral
    
    no_datapoints = length(t);
    int_cumulative = 0;
    % Trapezoidal numerical integration 
    for ii = 1:(no_datapoints - 1)
        semi_sum = (x(ii) + x(ii + 1))/2;
        int_ii = semi_sum * (t(ii + 1) - t(ii));
        int_cumulative = int_cumulative + int_ii;
    end
    integral = int_cumulative;
end

