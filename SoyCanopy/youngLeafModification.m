
% Qingfeng and Venkat, 2014-12-2

function mdy = youngLeafModification(md, Vx_sv)

[row, col] = size(md);

mdy = md;
mdy(row,   [4, 7:18]) = mdy(row,[4, 7:18])    * (0.25+0.25*Vx_sv);   % scaling to current Vx, for top leaf
mdy(row-1, [4, 7:18]) = mdy(row-1, [4, 7:18]) * (0.5 +0.25*Vx_sv);   % scaling to current Vx, for top but one leaf
mdy(row-2, [4, 7:18]) = mdy(row-2, [4, 7:18]) * (0.75+0.25*Vx_sv);   % scaling to current Vx, for top but two leaf

end

