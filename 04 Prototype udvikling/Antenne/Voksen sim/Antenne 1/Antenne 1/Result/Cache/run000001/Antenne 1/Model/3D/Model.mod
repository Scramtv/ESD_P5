'# MWS Version: Version 2025.5 - May 30 2025 - ACIS 34.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2.3 fmax = 2.6
'# created = '[VERSION]2025.0|34.0.1|20240830[/VERSION]


'@ use template: Antenna - Planar_1.cfg

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "GHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2.3", "2.6"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "2.3;2.45;2.6"
Dim sDefineAtName As String
sDefineAtName = "2.3;2.45;2.6"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: Copper (annealed)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .DispersiveFittingSchemeMu "Nth Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .SetMaterialUnit "GHz", "mm"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Component.New "component1"

'@ define brick: component1:groundplane

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "groundplane" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Ws/2", "Ws/2" 
     .Yrange "-Ls/2", "Ls/2" 
     .Zrange "-tc-h", "-h" 
     .Create
End With

'@ define material: FR-4 (lossy)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "4.3"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.025"
     .TanDFreq "10.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .SetActiveMaterial "all"
     .Colour "0.94", "0.82", "0.76"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ define brick: component1:substrate

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-Ws/2", "Ws/2" 
     .Yrange "-Ls/2", "Ls/2" 
     .Zrange "-h", "0" 
     .Create
End With

'@ define brick: component1:patch

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-Wp/2", "Wp/2" 
     .Yrange "-Lp/2", "Lp/2" 
     .Zrange "0", "tc" 
     .Create
End With

'@ activate local coordinates

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.ActivateWCS "local"

'@ move wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.MoveWCS "local", "0.0", "-Lp/2", "0.0"

'@ move wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.MoveWCS "local", "1", "0.0", "0.0"

'@ define brick: component1:inset1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "inset1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "0", "1" 
     .Yrange "0", "y0" 
     .Zrange "0", "tc" 
     .Create
End With

'@ boolean subtract shapes: component1:patch, component1:inset1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "component1:patch", "component1:inset1"

'@ move wcs

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.MoveWCS "local", "-2", "0.0", "0.0"

'@ define brick: component1:inset2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "inset2" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-1", "0" 
     .Yrange "0", "y0" 
     .Zrange "0", "tc" 
     .Create
End With

'@ boolean subtract shapes: component1:patch, component1:inset2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "component1:patch", "component1:inset2"

'@ define brick: component1:feedline

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "feedline" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "2" 
     .Yrange "-Ls/2+Lp/2", "0" 
     .Zrange "0", "tc" 
     .Create
End With

'@ activate global coordinates

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.ActivateWCS "global"

'@ boolean add shapes: component1:patch, component1:feedline

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Add "component1:patch", "component1:feedline"

'@ pick face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickFaceFromId "component1:patch", "3"

'@ define port:1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "1.61*6.32", "1.61*6.32"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1.61", "1.61*6.32"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define time domain solver parameters

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "True"
     .AutoNormImpedance "True"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ farfield plot options

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "True" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

'@ define material: Gold

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "Gold"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "4.561e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "4.561e+007"
     .Rho "19320.0"
     .ThermalType "Normal"
     .ThermalConductivity "314.0"
     .SpecificHeat "130", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "78"
     .PoissonsRatio "0.42"
     .ThermalExpansionRate "14"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: connector

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Component.New "connector"

'@ define brick: connector:connectorBase

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "connectorBase" 
     .Component "connector" 
     .Material "Gold" 
     .Xrange "-Wcon/2", "Wcon/2" 
     .Yrange "-Wcon/2", "Wcon/2" 
     .Zrange "0", "hcon" 
     .Create
End With

'@ define material: FR-4 (loss free)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "FR-4 (loss free)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "4.3"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .SetActiveMaterial "all"
     .Colour "0.75", "0.95", "0.85"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ define cylinder: connector:ConnectorIsolator

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Cylinder 
     .Reset 
     .Name "ConnectorIsolator" 
     .Component "connector" 
     .Material "FR-4 (loss free)" 
     .OuterRadius "PinInsCon/2" 
     .InnerRadius "Pincon/2" 
     .Axis "z" 
     .Zrange "-0.2", "hightSkrue-2.1" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ boolean insert shapes: component1:groundplane, connector:ConnectorIsolator

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Insert "component1:groundplane", "connector:ConnectorIsolator"

'@ boolean insert shapes: connector:connectorBase, connector:ConnectorIsolator

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Insert "connector:connectorBase", "connector:ConnectorIsolator"

'@ define cylinder: connector:solid1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "connector" 
     .Material "Gold" 
     .OuterRadius "tykSkrue/2" 
     .InnerRadius "PinInsCon/2" 
     .Axis "z" 
     .Zrange "hcon", "hightSkrue" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: connector:pin

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Cylinder 
     .Reset 
     .Name "pin" 
     .Component "connector" 
     .Material "Gold" 
     .OuterRadius "Pincon/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "-Pinlength", "hightSkrue+5" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ boolean insert shapes: connector:connectorBase, connector:pin

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Insert "connector:connectorBase", "connector:pin"

'@ define cylinder: connector:hole0

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Cylinder 
     .Reset 
     .Name "hole0" 
     .Component "connector" 
     .Material "Vacuum" 
     .OuterRadius "pinHole/2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "hcon" 
     .Xcenter "(Wcon/2)-(pinHole/2)-0.8" 
     .Ycenter "Wcon/2-0.8-pinHole/2" 
     .Segments "0" 
     .Create 
End With

'@ transform: mirror connector:hole0

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Transform 
     .Reset 
     .Name "connector:hole0" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror connector:hole0

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Transform 
     .Reset 
     .Name "connector:hole0" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror connector:hole0_1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Transform 
     .Reset 
     .Name "connector:hole0_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ boolean subtract shapes: connector:connectorBase, connector:hole0

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "connector:connectorBase", "connector:hole0"

'@ boolean subtract shapes: connector:connectorBase, connector:hole0_1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "connector:connectorBase", "connector:hole0_1"

'@ boolean subtract shapes: connector:connectorBase, connector:hole0_1_1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "connector:connectorBase", "connector:hole0_1_1"

'@ boolean subtract shapes: connector:connectorBase, connector:hole0_2

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solid.Subtract "connector:connectorBase", "connector:hole0_2"

'@ transform: rotate connector

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Transform 
     .Reset 
     .Name "connector" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "180", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: translate connector

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Transform 
     .Reset 
     .Name "connector" 
     .Vector "conPlaceX", "-conPlaceY", "-h-tc" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ delete component: connector

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Component.Delete "connector"

'@ define monitor: e-field (f=2.4)

'[VERSION]2025.5|34.0.1|20250530[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=2.4)" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "2.40" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-28.25", "28.25", "-26.15", "26.15", "-1.645", "10.2102" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: e-field (f=2.4)

'[VERSION]2025.5|34.0.1|20250530[/VERSION]
Monitor.Delete "e-field (f=2.4)"

'@ define farfield monitor: farfield (f=2.4)

'[VERSION]2025.5|34.0.1|20250530[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.4)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "2.40" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-28.25", "28.25", "-26.15", "26.15", "-1.645", "10.2102" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

