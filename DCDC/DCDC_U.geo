W=4;
H=20;
Wf = 2.2;
Hf = 15;

R=1;
a=2.5;
w=.025;
hf = .02;
hc = .25;
PI = 4.*Atan(1);
theta = Acos(w/R/2.);

Point(1) = {-W/2, -H/2, 0, hc};
Point(2) = { W/2, -H/2, 0, hc};
Point(3) = { W/2,  H/2, 0, hc};
Point(4) = {-W/2,  H/2, 0, hc};

Point(5) = {-Wf/2, -Hf/2, 0, hf};
Point(6) = { Wf/2, -Hf/2, 0, hf};
Point(7) = { Wf/2,  Hf/2, 0, hf};
Point(8) = {-Wf/2,  Hf/2, 0, hf};

Point(9) = {w,-R*Sin(theta),0, hf};
Point(11) = {w,R*Sin(theta),0, hf};

Point(12) = {-w,R*Sin(theta),0, hf};
Point(14) = {-w,-R*Sin(theta),0, hf};

Point(15) = {w, R+a,0,hf};
Point(16) = {0, R+a, 0, hf};
Point(17) = {-w,R+a,0,hf};

Point(18) = {-w, -(R+a),0,hf};
Point(19) = {0, -(R+a), 0, hf};
Point(20) = {w,-(R+a),0,hf};

Point(100) = {0, 0, 0, hf};

// Outer body
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(1) = {1, 2, 3, 4};

//Outline of fine mesh
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 5};
Line Loop(2) = {5, 6, 7, 8};

//Inclusion
Circle(9) = {9, 100, 11};
Line(10) = {11, 15};
Circle(11) = {15, 16, 17};
Line(12) = {17, 12};
Circle(13) = {12, 100, 14};
Line(14) = {14, 18};
Circle(15) = {18, 19, 20};
Line(16) = {20, 9};
Line Loop(3) = {9, 10, 11, 12, 13, 14, 15, 16};

Plane Surface(1) = {1, -2};
Plane Surface(2) = {2, -3};

Physical Surface(1) = {1};
Physical Surface(2) = {2};

Physical Line (30) = {1};
Physical Line(31) = {3};
Physical Line(40) = {10, 11, 12, 14, 15, 16};
Physical Line(41) = {9, 13};
Physical Point(500) = {1};
Physical Point(501) = {4};