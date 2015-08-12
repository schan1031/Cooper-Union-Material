function C = prtNextString(N,K)
%prtNextString Loop through permutations with replacement.
% prtNextString(N,K), when first called, returns a function handle.  This  
% function handle, when called, returns the next permutation with 
% replacement of K elements taken from the set 1:N. This can be useful
% when the number of such permutations is too large to hold in memory at
% once.  If the number of such permutations is not too large, use 
% COMBINATOR(N,K,'p','r') (on the FEX) instead.
%
% The number of permutations with replacement is:  N^K  
%   where N >= 1, K >= 0
%
% Examples:
%
%     % To use each permuation one at a time, put it in a loop.
%     N = 4;  % Length of the set.
%     K = 3;  % Number of samples taken for each sampling.
%     H = prtNextString(N,K);
%     for ii = 1:N^K
%         A = H();
%         % Do stuff with A: use it as an index, etc.
%     end
%
%
%     % To build all of the permutations, do this (See note below):
%     ROWS = N^K;
%     C = ones(ROWS,K);
%     for ii = 1:ROWS
%         C(ii,:) = H();
%     end
%     %Note this is a lot slower than using combinator(N,K,'p','r')
%
% The function handle will cycle through when the final permutation is
% returned. 
%
% See also,  nchoosek, perms, combinator, npermutek (both on the FEX)
%
% Author:   Matt Fig
% Contact:  popkenai@yahoo.com
% Date: 6/9/2009
% Reference:  http://mathworld.wolfram.com/BallPicking.html

% Copyright (c) 2013 New Folder Consulting
%
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.


if isempty(N) || K == 0
   C = [];  
   return
elseif numel(N)~=1 || N<=0 || ~isreal(N) || floor(N) ~= N 
    error('N should be one real, positive integer. See help.')
elseif numel(K)~=1 || K<0 || ~isreal(K) || floor(K) ~= K
    error('K should be one real non-negative integer. See help.')
end

WV = [];  % Initial WV, the working vector for looping.
BC = N^K;  % Tells us when to start all over.
CNT = 0;  % Initializer for nested func.
C = @nestfunc;   % Return argument is a func handle.

    function B = nestfunc()
    % The user is passed a handle to this function.    
        if CNT==0 || CNT==BC
            WV = ones(1,K);  % Here we are starting over or at the end.
            B = WV;
            CNT = 1;
            return
        end

        if WV(K) == N  % This col is as high as it can go.
            cnt = K-1; % Look for first col to update.
            
            while WV(cnt) == N
                cnt = cnt-1;  % Keep looking for first col to update.
            end
            
            WV(cnt) = WV(cnt) + 1; % Increase this col.
            WV((cnt+1):K) = 1; % And set the followers to 1.
        else
            WV(K) = WV(K) + 1; % This col is not done yet.
        end
        
        CNT = CNT + 1;
        B = WV;  % Return argument.
    end
end
