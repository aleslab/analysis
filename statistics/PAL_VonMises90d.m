%
%PAL_CumulativeNormal   Evaluation of Cumulative Normal Psychometric
%   Function
%
%   syntax: y = PAL_CumulativeNormal(params, x, {optional argument})
%
%   y = PAL_CumulativeNormal(params, x), where 'params' contains the four
%   parameters of a Psychometric Funtion (i.e., [alpha beta gamma lambda]),
%   returns the Psychometric Function evaluated at values in 'x'. 'x' is
%   array of any size. Note that beta is the inverse of the normal
%   distribution's standard deviation (or 'sigma').
%
%   x = PAL_CumulativeNormal(params, y, 'Inverse') returns the x-value at 
%   which the Psychometric Function evaluates to y.
%
%   dydx = PAL_CumulativeNormal(params, x, 'Derivative') returns the
%   derivative (slope of tangent line) of the Psychometric Function
%   evaluated at x.
%
%   'params' need not have four entries. A two element vector will be
%   interpreted as [alpha beta], a three element vector as [alpha beta
%   gamma]. Missing elements in 'params' will be assigned a value of 0.
%
%   This example returns the function value at threshold when gamma 
%   ('guess-rate') and lambda ('lapse-rate') both equal 0:
%       
%   y = PAL_CumulativeNormal([1 2 0 0], 1) returns:
%
%   y = 0.5000
%
%Introduced: Palamedes version 1.0.0 (NP)
%Modified: Palamedes version 1.0.2, 1.1.1, 1.2.0, 1.4.0, 1.4.4, 1.6.3 
%   (see History.m)

function y = PAL_VonMises90d(params, x, varargin)

[alpha, beta, gamma, lambda] = PAL_unpackParamsPF(params);

%Convert input params into radians first
%Multiply these by 2 to stretch -90 to 90 interval to the -180 to 180
x = deg2rad(x)*2;
alpha = deg2rad(alpha)*2;
%Beta is ~1/sigma.  So translate to degrees using: 180 deg/pi rad, then
beta = (((180/pi)*sqrt(2)*10)*beta);

if ~isempty(varargin)
 error('Not implemented yet')
else
    
    
    y = gamma + (1 - gamma - lambda)*von_mises_psy(x,alpha,beta);
end



%This subfunction uses the von_mises_cdf() to calculate a psychometric
%function.  
%A circular pdf is defined on 
    function p = von_mises_psy(x,mu,k)
        
        p = nan(size(x));
        %Perhaps vectorize at some point
        for iX = 1:length(x),
            
            thisX = x(iX)-mu;
                        
            if thisX>=0
                p(iX) = (von_mises_cdf(pi,thisX,k)-von_mises_cdf(0,thisX,k));
            else
                p(iX) = 1-((von_mises_cdf(0,thisX,k)-von_mises_cdf(-pi,thisX,k)));
            end
            
        end
    end


function cdf = von_mises_cdf ( x, a, b )

%*****************************************************************************80
%
%% VON_MISES_CDF evaluates the von Mises CDF.
%
%  Discussion:
%
%    Thanks to Cameron Huddleston-Holmes for pointing out a discrepancy
%    in the MATLAB version of this routine, caused by overlooking an
%    implicit conversion to integer arithmetic in the original FORTRAN,
%    JVB, 21 September 2005.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    17 November 2006
%
%  Author:
%
%    Geoffrey Hill
%
%    MATLAB translation by John Burkardt.
%
%  Reference:
%
%    Geoffrey Hill,
%    ACM TOMS Algorithm 518,
%    Incomplete Bessel Function I0: The von Mises Distribution,
%    ACM Transactions on Mathematical Software,
%    Volume 3, Number 3, September 1977, pages 279-284.
%
%    Kanti Mardia, Peter Jupp,
%    Directional Statistics,
%    Wiley, 2000, QA276.M335
%
%  Parameters:
%
%    Input, real X, the argument of the CDF.
%    A - PI <= X <= A + PI.
%
%    Input, real A, B, the parameters of the PDF.
%    -PI <= A <= PI,
%    0.0 < B.
%
%    Output, real CDF, the value of the CDF.
%
  a1 = 12.0;
  a2 = 0.8;
  a3 = 8.0;
  a4 = 1.0;
  c1 = 56.0;
  ck = 10.5;
%
% We expect -PI <= X - A <= PI.

  if ( x - a <= -pi )
    cdf = 0.0;
    return
  end

  if ( pi <= x - a )
    cdf = 1.0;
    return
  end

%  Convert the angle (X - A) modulo 2 PI to the range ( 0, 2 * PI ).
%
  z = b;

  u = mod ( x - a + pi, 2.0 * pi );

%   if ( u < 0.0 )
%     u = u + 2.0 * pi;
%   end
% 
   y = u - pi;
%
%  For small B, sum IP terms by backwards recursion.
%
  if ( z <= ck )

    v = 0.0;

    if ( 0.0 < z )

      ip = floor ( z .* a2 - a3 ./ ( z + a4 ) + a1 );
      p = ip;
      s = sin ( y );
      c = cos ( y );
      y = p .* y;
      sn = sin ( y );
      cn = cos ( y );
      r = 0.0;
      z = 2.0 ./ z;

      for n = 2 : ip
        p = p - 1.0;
        y = sn;
        sn = sn .* c - cn .* s;
        cn = cn .* c + y .* s;
        r = 1.0 ./ ( p .* z + r );
        v = ( sn ./ p + v ) .* r;
      end

    end

    cdf = ( u .* 0.5 + v ) ./ pi;
%
%  For large B, compute the normal approximation and left tail.
%
  else

    c = 24.0 .* z;
    v = c - c1;
    r = sqrt ( ( 54.0 ./ ( 347.0 ./ v + 26.0 - c ) - 6.0 + c ) ./ 12.0 );
    z = sin ( 0.5 .* y ) .* r;
    s = 2.0 .* z .* z;
    v = v - s + 3.0;
    y = ( c - s - s - 16.0 ) ./ 3.0;
    y = ( ( s + 1.75 ) .* s + 83.5 ) ./ v - y;
    arg = z .* ( 1.0 - s ./ y.^2 );
    erfx = erf ( arg );
    cdf = 0.5 .* erfx + 0.5;

  end

  %cdf(pi <= x - a) = 1.0;
  %cdf(-pi >= x - a) = 0.0;
  cdf = max ( cdf, 0.0 );
  cdf = min ( cdf, 1.0 );
   
      
  return
end


end
