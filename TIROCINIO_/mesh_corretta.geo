//================================================================================
// Gmsh Script: Dominio Completo con Boundary Layer Field
// Versione: Modificata per includere controllo altezza prima cella (y+ ~ 1)
//==============================================================================

//------------------------------------------------------------------------------
// 1. PARAMETRI GLOBALI E GEOMETRICI
//------------------------------------------------------------------------------

// Parametri Base
D = 1;
r = 0.05*D;
G_angle_deg = 2.8;
G_angle_rad = G_angle_deg * Pi / 180.;

// Parametri Mesh Caratteristici
lcBody = D / 80; // Dimensione base vicino al corpo
lcSlot = lcBody / 2;
lcIntermediate = lcBody * 8;
lcMax = D * 3;

// Calcoli Geometria Corpo Interno
cx = r;
cy_top = D/2 - r;
angle_center_sup = 135 * Pi / 180;
angle_half_slot = G_angle_rad / 2.0;
angle_A1 = angle_center_sup - angle_half_slot;
angle_A = angle_center_sup + angle_half_slot;

// Calcoli Geometria Box Intermedio
W_half_domain = 10.5*D;
Width_orig = 2 * W_half_domain;
Width_small_sq = Width_orig / 5.0;
Half_Width_small_sq = Width_small_sq / 2.0;
X_center_body = 0.5*D;
Y_center_body = 0;
Xmin_small_sq = X_center_body - Half_Width_small_sq;
Xmax_small_sq = X_center_body + Half_Width_small_sq;
Ymax_small_sq = Half_Width_small_sq;

// Calcoli Geometria Box Esterno
L_upstream = 6*D;
L_downstream = 25*D;
Xmin_large_rect = -L_upstream;
Xmax_large_rect = L_downstream;
Ymax_large_rect = W_half_domain;

// Parametri per Boundary Layer (Stimati per y+ ~ 1 a Re=40000)
target_y_plus = 1;
nu_estimate = 1.0 / 40000; // Assumendo Uinf=1, D=1
u_tau_estimate = 0.05;     // Stima MOLTO approssimativa, da verificare/raffinare
first_cell_height = (target_y_plus * nu_estimate) / u_tau_estimate; // ~0.0005

Printf("INFO: Target first cell height (y) = %g for y+ ~ %g", first_cell_height, target_y_plus);

//------------------------------------------------------------------------------
// 2. PUNTI (Metà Dominio Superiore y>=0)
//------------------------------------------------------------------------------

// Punti Corpo Centrale (1xx)
Point(104) = {cx, cy_top, 0, lcBody};
Point(103) = { D, D/2, 0, lcBody};
Point(114) = { 0, cy_top, 0, lcBody};
Point(113) = { cx, D/2, 0, lcBody};
Point(121) = {cx + r*Cos(angle_A1), cy_top + r*Sin(angle_A1), 0, lcSlot};
Point(122) = {cx + r*Cos(angle_A),  cy_top + r*Sin(angle_A),  0, lcSlot};

// Punti Box Intermedio (3xx)
Point(303) = {Xmax_small_sq, Ymax_small_sq, 0, lcIntermediate};
Point(304) = {Xmin_small_sq, Ymax_small_sq, 0, lcIntermediate};
Point(314) = {Xmin_small_sq, 0.9, 0, lcIntermediate};    // Y manuale
Point(351) = {Xmin_small_sq, 1.4136, 0, lcIntermediate};   // Y manuale
Point(352) = {Xmin_small_sq, 1.3316, 0, lcIntermediate};   // Y manuale

// Punti Box Esterno (6xx)
Point(603) = {Xmax_large_rect, Ymax_large_rect, 0, lcMax};
Point(604) = {Xmin_large_rect, Ymax_large_rect, 0, lcMax};
Point(614) = {Xmin_large_rect, 0.9, 0, lcMax};    // Y manuale
Point(651) = {Xmin_large_rect, 1.4136, 0, lcMax};   // Y manuale
Point(652) = {Xmin_large_rect, 1.3316, 0, lcMax};   // Y manuale
Point(655) = {Xmin_large_rect, Ymax_small_sq, 0, lcMax};
Point(623) = {Xmax_large_rect, Ymax_small_sq, 0, lcMax};
Point(643) = {Xmax_small_sq, Ymax_large_rect, 0, lcMax};
Point(600) = {Xmin_small_sq, Ymax_large_rect, 0, lcMax};

// Punti Asse Simmetria y=0 (901-906) - NON VERRANNO DUPLICATI
Point(901) = {0, 0, 0, lcBody};
Point(902) = {D, 0, 0, lcBody};
Point(903) = {Xmin_small_sq, 0, 0, lcIntermediate};
Point(904) = {Xmax_small_sq, 0, 0, lcIntermediate};
Point(905) = {Xmin_large_rect, 0, 0, lcMax};
Point(906) = {Xmax_large_rect, 0, 0, lcMax};

// Punti Aggiunti Manualmente (907-915) - VERRANNO DUPLICATI (tranne 913)
Point(907) = {Xmin_small_sq, 1.3755, 0, lcIntermediate};
Point(908) = {Xmin_large_rect, 1.3755, 0, lcMax};
P121x = cx + r*Cos(angle_A1); P121y = cy_top + r*Sin(angle_A1);
P122x = cx + r*Cos(angle_A);  P122y = cy_top + r*Sin(angle_A);
Point(909) = {(P121x+P122x)/2, (P121y+P122y)/2, 0, lcSlot};
Point(910) = {X_center_body, D/2, 0, lcBody};
Point(911) = {X_center_body, Ymax_small_sq, 0, lcIntermediate};
Point(912) = {X_center_body, Ymax_large_rect, 0, lcMax};
Point(913) = {13.8, 0, 0, lcIntermediate}; // Su asse y=0 - NON VERRÀ DUPLICATO
Point(914) = {13.8, Ymax_small_sq, 0, lcIntermediate};
Point(915) = {13.8, Ymax_large_rect, 0, lcMax};


//------------------------------------------------------------------------------
// 3. CURVE (Metà Dominio Superiore y>=0)
//------------------------------------------------------------------------------

Line(206) = {114, 901}; Circle(205) = {122, 104, 114}; Circle(204) = {121, 104, 113}; Line(202) = {103, 902};
Line(404) = {114, 314}; Line(413) = {113, 304}; Line(406) = {103, 303}; Line(451) = {121, 351}; Line(452) = {122, 352}; Line(491) = {901, 903}; Line(492) = {902, 904};
Line(503) = {904, 303}; Line(506) = {351, 304}; Line(508) = {352, 314}; Line(509) = {314, 903};
Line(704) = {314, 614}; Line(711) = {351, 651}; Line(712) = {352, 652}; Line(734) = {304, 655}; Line(743) = {303, 643}; Line(700) = {304, 600}; Line(791) = {903, 905};
Line(805) = {906, 623}; Line(807) = {623, 603}; Line(810) = {600, 604}; Line(811) = {655, 604}; Line(812) = {604, 655}; Line(813) = {651, 655}; Line(815) = {652, 614}; Line(816) = {614, 905};
Line(299) = {901, 902}; Line(599) = {903, 901}; Line(598) = {902, 904}; Line(899) = {905, 903};
Line(900) = {909, 907}; Line(901) = {907, 908}; Line(507) = {907, 351}; Line(210) = {909, 121}; Line(814) = {908, 651}; Line(1003) = {908,652}; Line(1002) = {907, 352}; Line(1001) = {909, 122}; Line(1004) = {911, 912}; Line(1009) = {913, 914}; Line(1010) = {914, 915}; Line(504) = {304, 911}; Line(1005) = {303, 911}; Line(809) = {643, 912}; Line(1006) = {912, 600}; Line(1007) = {910, 911}; Line(203) = {113, 910}; Line(1008) = {103, 910}; Line(792) = {904, 913}; Line(1013) = {913, 906}; Line(723) = {303, 914}; Line(1011) = {914, 623}; Line(808) = {643, 915}; Line(1012) = {915, 603}; Line(898) = {913, 906};


//------------------------------------------------------------------------------
// 4. SURFACES (Metà Dominio Superiore y>=0)
//------------------------------------------------------------------------------

Curve Loop(1) = {816, -791, -509, 704};      Plane Surface(1) = {1};
Curve Loop(2) = {815, -704, -508, 712};      Plane Surface(2) = {2};
Curve Loop(4) = {-813, -711, 506, 734};      Plane Surface(4) = {4};
Curve Loop(7) = {509, -491, -206, 404};      Plane Surface(7) = {7};
Curve Loop(8) = {508, -404, -205, 452};      Plane Surface(8) = {8};
Curve Loop(10) = {-506, -451, 204, 413};     Plane Surface(10) = {10};
Curve Loop(13) = {406, -503, -492, -202};    Plane Surface(13) = {13};
Curve Loop(15) = {1003, -712, -1002, 901};   Plane Surface(15) = {15};
Curve Loop(16) = {-814, -901, 507, 711};     Plane Surface(16) = {16};
Curve Loop(17) = {1002, -452, -1001, 900};   Plane Surface(17) = {17};
Curve Loop(18) = {-507, -900, 210, 451};     Plane Surface(18) = {18};
Curve Loop(19) = {413, 504, -1007, -203};    Plane Surface(19) = {19};
Curve Loop(20) = {1007, -1005, -406, 1008};  Plane Surface(20) = {20};
Curve Loop(21) = {700, -1006, -1004, -504};  Plane Surface(21) = {21};
Curve Loop(22) = {1004, -809, -743, 1005};  Plane Surface(22) = {22};
Curve Loop(23) = {811, -810, -700, 734};     Plane Surface(23) = {23};
Curve Loop(24) = {503, 723, -1009, -792};    Plane Surface(24) = {24};
Curve Loop(25) = {743, 808, -1010, -723};    Plane Surface(25) = {25};
Curve Loop(26) = {1010, 1012, -807, -1011};  Plane Surface(26) = {26};
Curve Loop(27) = {1009, 1011, -805, -898};   Plane Surface(27) = {27};

// Lista superfici originali (da duplicare)

original_surfaces[] = {1, 2, 4, 7, 8, 10, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27};


//------------------------------------------------------------------------------
// 5. MIRRORING DELLA GEOMETRIA ACROSS Y=0 (XZ PLANE)
//------------------------------------------------------------------------------


Symmetry {0, 1, 0, 0} {
  Duplicata{ Surface{original_surfaces[]}; }
}

//------------------------------------------------------------------------------
// 6. RECUPERA LISTA SUPERFICI TOTALI (POST MIRRORING)
//------------------------------------------------------------------------------
// Recupera gli ID di TUTTE le superfici definite (originali + specchiate)
all_surfaces_list[] = Surface{:};
Printf("INFO: Total number of surfaces (original + mirrored) = %g", #all_surfaces_list[]);


//------------------------------------------------------------------------------
// 7. DEFINIZIONE GRUPPI FISICI 2D (CURVE DI CONTORNO)
//------------------------------------------------------------------------------
// Definiti PRIMA del Boundary Layer Field perché serve il Physical Group "bodyWall"


//+
Physical Curve("inlet", 1) = {811, 813, 814, 1003, 815, 816, 1015, 1020, 1050, 1055, 1025, 1090};
//+
Physical Curve("outlet", 2) = {807, 805, 1112, 1107};
//+
Physical Curve("topWall", 3) = {810, 1006, 809, 808, 1012};
//+
Physical Curve("bottomWall", 4) = {1091, 1081, 1086, 1101, 1106};
//+
Physical Curve("bodyWall", 5) = {203, 1008, 202, 1048, 1078, 1073, 1032, 206, 1037, 1042, 204, 205}; // Tag numerico = 5
//+
Physical Curve("actuatorSlots", 6) = {210, 1001, 1062, 1067};



// 9. DISCRETIZZAZIONE BORDI (TRANSFINITE CURVE)
//------------------------------------------------------------------------------

// 9.1 Definizioni per Curve Originali (y>=0)
Transfinite Curve {205} = 20 Using Progression 1.18;
Transfinite Curve {508} = 20 Using Progression 1.08;
Transfinite Curve {815} = 20 Using Progression 1.08;
Transfinite Curve {204} = 20 Using Progression 1.18;
Transfinite Curve {506} = 20 Using Progression 1.13;
Transfinite Curve {813} = 20 Using Progression 1.13;
Transfinite Curve {210} = 6 Using Progression 1;
Transfinite Curve {1001} = 6 Using Progression 1;
Transfinite Curve {507} = 6 Using Progression 1;
Transfinite Curve {1002} = 6 Using Progression 1;
Transfinite Curve {814} = 6 Using Progression 1;
Transfinite Curve {1003} = 6 Using Progression 1;
Transfinite Curve {451} = 35 Using Progression 1.18;
Transfinite Curve {413} = 35 Using Progression 1.18;
// Transfinite Curve {405} = 31 Using Progression 1.18; // Curva 405 non definita
Transfinite Curve {452} = 35 Using Progression 1.18;
Transfinite Curve {404} = 35 Using Progression 1.18;
Transfinite Curve {491} = 35 Using Progression 1.18; // Su asse y=0
Transfinite Curve {900} = 35 Using Progression 1.18;
Transfinite Curve {406} = 35 Using Progression 1.18;
Transfinite Curve {206} = 40 Using Progression 1.03;
Transfinite Curve {509} = 40 Using Progression 0.97;
Transfinite Curve {816} = 40 Using Progression 0.97;
Transfinite Curve {711} = 11 Using Progression 1.1;
Transfinite Curve {734} = 11 Using Progression 1.1;
Transfinite Curve {712} = 11 Using Progression 1.1;
Transfinite Curve {901} = 11 Using Progression 1.1;
Transfinite Curve {704} = 11 Using Progression 1.1;
Transfinite Curve {791} = 11 Using Progression 1.1; // Su asse y=0
Transfinite Curve {202} = 30 Using Progression 1.06;
Transfinite Curve {503} = 30;
Transfinite Curve {1009} = 30;
Transfinite Curve {492} = 35 Using Progression 1.18; // Su asse y=0
Transfinite Curve {811} = 25 Using Progression 1.1;
Transfinite Curve {203} = 25 Using Progression 1.08;
Transfinite Curve {504} = 25 Using Progression 1;
Transfinite Curve {743} = 25 Using Progression 1.1;
Transfinite Curve {1007} = 35 Using Progression 1.18;
Transfinite Curve {1010} = 25 Using Progression 1.1;
Transfinite Curve {807} = 25 Using Progression 1.1;
Transfinite Curve {810} = 11 Using Progression 1.1;
Transfinite Curve {700} = 25 Using Progression 1.1;
Transfinite Curve {1008} = 25 Using Progression 1.08;
Transfinite Curve {1005} = 25 Using Progression 1;
Transfinite Curve {1004} = 25 Using Progression 1.1;
Transfinite Curve {1006} = 25 Using Progression 1;
Transfinite Curve {809} = 25 Using Progression 1;
Transfinite Curve {805} = 30;
Transfinite Curve {723} = 20 Using Progression 1.05;
Transfinite Curve {792} = 20 Using Progression 1.05; // Su asse y=0
Transfinite Curve {808} = 20 Using Progression 1.05;
Transfinite Curve {898} = 8 Using Progression 1.13;  // Su asse y=0
Transfinite Curve {1011} = 8 Using Progression 1.13;
Transfinite Curve {1012} = 8 Using Progression 1.13;

// 9.2 Definizioni per Curve Specchiate (y<0) - Da IDs GUI
Transfinite Curve {1037} = 20 Using Progression 1/1.18; // Mirror di 205
Transfinite Curve {1022} = 20 Using Progression 1/1.08; // Mirror di 508
Transfinite Curve {1020} = 20 Using Progression 1.08; // Mirror di 815
Transfinite Curve {1042} = 20 Using Progression 1.18; // Mirror di 204
Transfinite Curve {1027} = 20 Using Progression 1.13; // Mirror di 506
Transfinite Curve {1025} = 20 Using Progression 1/1.13; // Mirror di 813 
Transfinite Curve {1067} = 6 Using Progression 1; // Mirror di 210
Transfinite Curve {1062} = 6 Using Progression 1/1; // Mirror di 1001
Transfinite Curve {1057} = 6 Using Progression 1; // Mirror di 507
Transfinite Curve {1052} = 6 Using Progression 1/1; // Mirror di 1002
Transfinite Curve {1055} = 6 Using Progression 1/1; // Mirror di 814
Transfinite Curve {1050} = 6 Using Progression 1; // Mirror di 1003
Transfinite Curve {1041} = 35 Using Progression 1/1.18; // Mirror di 451
Transfinite Curve {1043} = 35 Using Progression 1.18; // Mirror di 413
Transfinite Curve {1038} = 35 Using Progression 1.18; // Mirror di 452
Transfinite Curve {1033} = 35 Using Progression 1.18; // Mirror di 404
// Transfinite Curve {491} = 31 Using Progression 1.18; // Su asse - NON DUPLICARE
Transfinite Curve {1063} = 35 Using Progression 1.18; // Mirror di 900
Transfinite Curve {1045} = 35 Using Progression 1.18; // Mirror di 406
Transfinite Curve {1032} = 40 Using Progression 1/1.03; // Mirror di 206
Transfinite Curve {1017} = 40 Using Progression 1/0.97; // Mirror di 509
Transfinite Curve {1015} = 40 Using Progression 0.97; // Mirror di 816
Transfinite Curve {1026} = 11 Using Progression 1/1.1; // Mirror di 711 
Transfinite Curve {1028} = 11 Using Progression 1.1; // Mirror di 734
Transfinite Curve {1023} = 11 Using Progression 1.1; // Mirror di 712
Transfinite Curve {1053} = 11 Using Progression 1.1; // Mirror di 901
Transfinite Curve {1018} = 11 Using Progression 1.1; // Mirror di 704
// Transfinite Curve {791} = 11 Using Progression 1.1; // Su asse - NON DUPLICARE
Transfinite Curve {1048} = 30 Using Progression 1/1.06; // Mirror di 202
Transfinite Curve {1046} = 30;                       // Mirror di 503
Transfinite Curve {1097} = 30;                       // Mirror di 1009
// Transfinite Curve {492} = 31 Using Progression 1.18; // Su asse - NON DUPLICARE
Transfinite Curve {1090} = 25 Using Progression 1.1; // Mirror di 811
Transfinite Curve {1073} = 25 Using Progression 1/1.08; // Mirror di 203
Transfinite Curve {1071} = 25 Using Progression 1;  // Mirror di 504
Transfinite Curve {1087} = 25 Using Progression 1/1.1; // Mirror di 743
Transfinite Curve {1072} = 35 Using Progression 1/1.18; // Mirror di 1007
Transfinite Curve {1102} = 25 Using Progression 1/1.1; // Mirror di 1010
Transfinite Curve {1107} = 25 Using Progression 1/1.1; // Mirror di 807
Transfinite Curve {1091} = 11 Using Progression 1/1.1; // Mirror di 810
Transfinite Curve {1080} = 25 Using Progression 1.1; // Mirror di 700
Transfinite Curve {1078} = 25 Using Progression 1.08; // Mirror di 1008
Transfinite Curve {1076} = 25 Using Progression 1;  // Mirror di 1005
Transfinite Curve {1082} = 25 Using Progression 1/1.1; // Mirror di 1004
Transfinite Curve {1081} = 25 Using Progression 1;  // Mirror di 1006
Transfinite Curve {1086} = 25 Using Progression 1;  // Mirror di 809
Transfinite Curve {1112} = 30;                       // Mirror di 805
Transfinite Curve {1096} = 20 Using Progression 1.05; // Mirror di 723
// Transfinite Curve {792} = 20 Using Progression 1.05; // Su asse - NON DUPLICARE
Transfinite Curve {1101} = 20 Using Progression 1.05; // Mirror di 808
// Transfinite Curve {898} = 8 Using Progression 1.13;  // Su asse - NON DUPLICARE
Transfinite Curve {1108} = 8 Using Progression 1/1.13; // Mirror di 1011
Transfinite Curve {1106} = 8 Using Progression 1.13; // Mirror di 1012


//------------------------------------------------------------------------------
// 10. APPLICA TRANSFINITE E RECOMBINE ALLE SUPERFICI 2D
//------------------------------------------------------------------------------
// Applica l'algoritmo Transfinite e Recombine a ciascuna superficie
// iterando sulla lista recuperata precedentemente (all_surfaces_list).
// Il Background Field definito prima influenzerà la dimensione interna.
For i In {0:#all_surfaces_list[]-1}
  Transfinite Surface{ all_surfaces_list[i] };
  Recombine Surface{ all_surfaces_list[i] };
EndFor


//-------------------------------------
// 11. ESTRUSIONE A SINGOLO LAYER (2.5D)
//-------------------------------------
Z_thickness = D * 0.1;
// Estrudi TUTTE le superfici 2D (originali + specchiate)
// Usiamo all_surfaces_list[] invece della lista esplicita per robustezza
out[] = Extrude {0, 0, Z_thickness} {
  Surface{all_surfaces_list[]};
  Layers{1};
  Recombine;
};


//-------------------------------------
// 12. GRUPPI FISICI 3D (Mantenendo gli ID forniti dall'utente)
//-------------------------------------
// Volume
all_volumes_created[] = Volume{:};
Physical Volume("Volume", 100) = {all_volumes_created[]};



//+
Physical Surface("inlet", 1) = {1451, 1165, 1297, 1275, 1143, 1121, 1561, 1583, 1715, 1737, 1605, 1891};
//+
Physical Surface("outlet", 2) = {1525, 1547, 1987, 1965};
//+
Physical Surface("topWall", 3) = {1455, 1411, 1433, 1499, 1521};
//+
Physical Surface("bottomWall", 4) = {1895, 1851, 1873, 1939, 1961};
//+
Physical Surface("bodyWall", 5) = {1397, 1375, 1265, 1705, 1837, 1815, 1635, 1195, 1679, 1657, 1239, 1217};
//+
Physical Surface("actuatorSlots", 6) = {1789, 1767, 1349, 1327};
//+
Physical Surface("frontAndBack", 7) = {1464, 1420, 1442, 1508, 1530, 1552, 1486, 1376, 1398, 1266, 1178, 1156, 1134, 1574, 1596, 1618, 1904, 1860, 1882, 1926, 1948, 1706, 1838, 1816, 1970, 1992, 1200, 1640, 1662, 1684, 1244, 1222, 1728, 1750, 1310, 1288, 17, 1354, 18, 1332, 1772, 1794, 1064, 1059, 1089, 1079, 1084, 1099, 1094, 1109, 1104, 26, 27, 24, 25, 22, 21, 23, 4, 1, 2, 1014, 1024, 1019, 1044, 13, 20, 19, 1074, 1069, 1039, 1034, 1029, 7, 10, 8, 15, 16, 1049, 1054};

//-------------------------------------
// 13. GENERAZIONE MESH 3D
//-------------------------------------
Mesh 3; 





