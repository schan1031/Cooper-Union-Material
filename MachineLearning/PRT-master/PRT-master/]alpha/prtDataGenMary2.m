function DataSet = prtDataGenMary2
% prtDataGenMary2  Generates some unimodal m-ary example data for the prt.
%  The data is distributed:
%       H1: N([-1 0],0.5*eye(2))
%       H2: N([0 1],0.1*eye(2))
%       H3: N([1 0],0.25*eye(2))
%
% Syntax: [X, Y] = prtDataGenMary2
%
% Inputs: 
%   none
%
% Outputs:
%   X - 300x2 Unimodal data
%   Y - 300x1 Class labels
%
% Example:
%   [X, Y] = prtDataGenMary2;
%   prtDataPlot(X,Y)
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: prtDataGenUnimodal, prtDataGenBimodal

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



rvH1 = prtRvMvn('mu',[-1 0],'sigma',0.5*eye(2));
rvH2 = prtRvMvn('mu',[0 1],'sigma',0.1*eye(2));
rvH3 = prtRvMvn('mu',[1 0],'sigma',0.25*eye(2));
X = cat(1,draw(rvH1,100),draw(rvH2,100),draw(rvH3,100));
Y = prtUtilY(0,100,100,100);

DataSet = prtDataSetClass(X,Y,'name','prtDataGenMary2');
