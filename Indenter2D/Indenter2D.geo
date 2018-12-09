H1 = 1.;
H2 = 2.;
W  = 10;
Wi = 2;
h = .05;

Point(1) = {-W/2,  0,     0, h};
Point(2) = {-W/2., H1,    0, h};
Point(3) = {-W/2., H1+H2, 0, h};
Point(4) = {-Wi/2, H1+H2, 0, h};
Point(5) = { Wi/2, H1+H2, 0, h};
Point(6) = { W/2,  H1+H2, 0, h};
Point(7) = { W/2,  H1,    0, h};
Point(8) = { W/2,  0,     0, h};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {7, 2};
Line(9) = {8, 1};

Line Loop(1) = {1, -8, 7, 9};
Line Loop(2) = {2, 3, 4, 5, 6, 8};
Plane Surface(1) = {1};
Plane Surface(2) = {2};

Physical Surface(1) = {1};
Physical Surface(2) = {2};
Physical Line(30) = {4};
Physical Line(40) = {9};
Physical Point(500) = {1};
