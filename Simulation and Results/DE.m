close all

model = createpde(2);

R1 = [3,4,0.3,0.7,0.7,0.3,0.3,0.3,0.7,0.7]';
geom = R1;
gd = decsg(geom);
geometryFromEdges(model, gd); % geometryFromEdges for 2-D

pdegplot(model,"EdgeLabels","on") % "EdgeLabels" for 2-D

H0 = eye(2);
R0 = [1;1];
applyBoundaryCondition(model, "dirichlet", "Edge",[1,2,3],"h",H0,"r",R0);

m = 0;
d = eye(1);
c = [-1; -0.01];
a = [1; 1];
f = [0.024; 0];
specifyCoefficients(model,"m",m,"d",d,"c",c,"a",a,"f",f);
