W=4;
H=20;
Wf = 1.2;
Hf = 18;
ratio=3/4;

R=1;
a=2.5;
w=.025;
hf = .05;
hc = .25;
PI = 4.*Atan(1);
theta = Acos(w/R/2.);

Point(1) = {-W/2, -H/2, 0, hc};
Point(2) = { W/2, -H/2, 0, hc};
Point(3) = { W/2,  H/2, 0, hc};
Point(4) = {-W/2,  H/2, 0, hc};

Point(7) = { Wf/2,  Hf/2, 0, hf};
Point(8) = {-Wf/2,  Hf/2, 0, hf};
Point(30) = {-Wf/2, R+ratio*a, 0, hf};
Point(31) = {-w,    R+ratio*a, 0, hf};
Point(32) = { w,    R+ratio*a, 0, hf};
Point(33) = { Wf/2, R+ratio*a, 0, hf};

Point(5) = {-Wf/2, -Hf/2, 0, hf};
Point(6) = { Wf/2, -Hf/2, 0, hf};
Point(40) = { Wf/2, -R-ratio*a, 0, hf};
Point(41) = { w,    -R-ratio*a, 0, hf};
Point(42) = {-w,    -R-ratio*a, 0, hf};
Point(43) = {-Wf/2, -R-ratio*a, 0, hf};

Point(9) = {w,-R*Sin(theta),0, hc};
Point(11) = {w,R*Sin(theta),0, hc};

Point(12) = {-w,R*Sin(theta),0, hc};
Point(14) = {-w,-R*Sin(theta),0, hc};

Point(15) = {w, R+a,0,hf};
Point(16) = {0, R+a, 0,hf};
Point(17) = {-w,R+a,0,hf};

Point(18) = {-w, -(R+a),0,hf};
Point(19) = {0, -(R+a), 0,hf};
Point(20) = {w,-(R+a),0,hf};

Point(100) = {0, 0, 0, hf};

// Outer body
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(1) = {1, 2, 3, 4};

// Upper refined area
Line(50) = {32, 33};
Line(51) = {33, 7};
Line(52) = {7, 8};
Line(53) = {8, 30};
Line(54) = {30, 31};
Line(55) = {31, 16};
Line(57) = {16, 32};
Line Loop(2) = {50, 51, 52, 53, 54, 55, 57};
Plane Surface(2) = {2};

// Lower refined area
Line(60) = {42, 43};
Line(61) = {43, 5};
Line(62) = {5, 6};
Line(63) = {6, 40};
Line(64) = {40, 41};
Line(65) = {41, 19};
Line(67) = {19, 42};
Line Loop(3) = {60, 61, 62, 63, 64, 65, 67};
Plane Surface(3) = {3};

// Rest of inclusion
Circle(70) = {9, 100, 11};
Line(71) = {11, 32};
Line(72) = {31, 12};
Circle(73) = {12, 100, 14};
Line(74) = {14, 42};
Line(75) = {41, 9};
Line Loop(4) = {70, 71, 50, 51, 52, 53, 54, 72, 73, 74, 60, 61, 62, 63, 64, 75};
Plane Surface(4) = {1, -4};

Physical Surface(2) = {2, 3};
Physical Surface(1) = {4};

Physical Line (30) = {1};
Physical Line(31) = {3};
Physical Line(40) = {55, 57, 65, 67};
Physical Point(500) = {1};
Physical Point(501) = {4};