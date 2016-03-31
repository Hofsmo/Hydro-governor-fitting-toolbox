function caseStruct = createVFARXStruct(p, f, t, caseStruct, window, fraction)

caseStruct.sys = iddata(p,f,t(2)-t(1));
if nargin > 4 && ~isempty(window)
    p = smooth(p,window);
    f = smooth(f,window);
end
if nargin > 5
    p = decimate(p,fraction);
    f = decimate(f,fraction);
    t = decimate(t,fraction);
end
caseStruct.p = p;
caseStruct.f = f;
caseStruct.t = t;
caseStruct.td = iddata(p,f,t(2)-t(1));